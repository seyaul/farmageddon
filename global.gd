extends Node

var enemyCount: int
var numLevelsComplete : int = 0
var numResets : int = 0
var playerHealth : int
var playerGold : int
var playerExp : int
var player_scene = preload("res://Scenes/player.tscn")
var lifesteal_popup_scene = preload("res://Scenes/lifesteal_popup.tscn")
var campfire_popup_instance = null
var player_stats: PlayerStats
var all_gun_stats: AllGunStats
var card_pool: Array = [] 
var active_weapons: Array[String] = ["AKorn47"]
var weight_adjustments: Dictionary = {} 
const CARD_BASE_WEIGHTS = {
	"common": 10, 
	"medium": 6,   
	"rare": 2      
} 
var card_skip_counts = {}
var playerInstance : CharacterBody2D
var playerHealthNode : Node
var playerMaxHealth: int
var playerCurrHealth : float
var tutorial : bool
var num_enemies_defeated : int

var elite_room : int = 1
signal campfire_selected

# WIP variables
var newGame : bool = true

# To be implemented
var powerUps : Array
var stats : Array
var weapons : Array


signal gameStarted 
signal newGameStarted
signal bossLevelStarted
signal newWeaponUnlocked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#numRuns = 0
	#enemyCount = 0
	
	# Reward scene stuff
	player_stats = PlayerStats.new()
	all_gun_stats = AllGunStats.new()
	initialize_card_pool()
	
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	playerMaxHealth = playerHealthNode.player_max_health
	playerHealth = playerMaxHealth + player_stats.additional_max_health
	
	playerGold = 0
	playerExp = 0
	
	if not is_connected("campfire_selected", Callable(self, "_on_campfire_selected")):
		connect("campfire_selected", Callable(self, "_on_campfire_selected"))
		print("connected campfire_selected signal")
	
	Global.connect("mob_died", Callable(self, "_on_mob_died"))
	Global.connect("gameStarted", Callable(self, "_game_started"))
	Global.connect("newGameStarted", Callable(self, "_new_game_started"))
	Global.connect("bossLevelStarted", Callable(self, "_boss_level_started"))
	#emit_signal("newGameStarted")
	pass # Replace with function body.

func _on_campfire_selected():
	Global.playerHealth = playerMaxHealth + player_stats.additional_max_health
	show_campfire_heal_popup()

func show_campfire_heal_popup():
	var existing_popup = get_tree().root.find_child("CampfireRoom", true, false)
	if existing_popup:
		existing_popup.queue_free()
		await get_tree().process_frame

	var campfire_popup_scene = preload("res://Scenes/CampfireRoom.tscn")
	campfire_popup_instance = campfire_popup_scene.instantiate()
	
	var ui_layer = get_tree().root.get_node_or_null("UserInterfaceLayer")
	if ui_layer:
		ui_layer.add_child(campfire_popup_instance)
	else:
		ui_layer = CanvasLayer.new()
		ui_layer.name = "UserInterfaceLayer2"
		get_tree().root.add_child(ui_layer)
	ui_layer.add_child(campfire_popup_instance)
	campfire_popup_instance.global_position = Vector2(50, 50)
	campfire_popup_instance.show_popup()

func show_lifesteal_popup():
	print("LIFESTEAL SHOWING AHHH")
	if playerInstance:
		var popup = lifesteal_popup_scene.instantiate()
		var ui_layer = get_tree().root.get_node_or_null("UserInterfaceLayer")
		if ui_layer:
			ui_layer.add_child(popup)
		else:
			ui_layer = CanvasLayer.new()
			ui_layer.name = "UserInterfaceLayer2"
			get_tree().root.add_child(ui_layer)
		ui_layer.add_child(popup)
		popup.show_popup()

func _on_mob_died() -> void:
	if Global.playerHealth >= Global.playerHealthNode.player_max_health + Global.player_stats.additional_max_health:
		return

	var lifesteal_roll = randf()
	if lifesteal_roll <= Global.player_stats.lifesteal_chance:
		playerHealthNode.heal(1)
		show_lifesteal_popup()
		print("lifesteal activated yippee!")
	else:
		print("no lifesteal for u")

func initialize_card_pool():
	# weights/rarities subject to change
	card_pool = [
		create_card("Max Health Boost", "Increases max health by 10.", "rare", 
			preload("res://Sprites/healing (1).png"), false, 1.0, {"modifies_player_stats": true, "additional_max_health": 10}),
		create_card("Speed Boost", "Increases movement speed by " + str(1 * elite_room) + ".", "medium", 
			preload("res://Sprites/gold (1).png"), false, 1.0, {"modifies_player_stats": true, "additional_speed": 1 * Global.elite_room}), # probs shld be common
		create_card("Heating Rate Reduction", "Reduces weapon heating rate time by " + str(20 * elite_room) + "%.", "common", 
			preload("res://Sprites/xp (1).png"), true, 1.0, {"modifies_gun_stats": true, "cooldown_speed_modifier": 0.8 / Global.elite_room}),
		create_card("Fire Rate Buff", "Increases fire rate by " + str(15 * elite_room) + "%.", "common", 
			preload("res://Sprites/xp (1).png"), true, 1.0, {"modifies_gun_stats": true, "fire_rate_modifier": 1 + 0.15 * Global.elite_room}),
		create_card("Lifesteal Ability", "Chance to regain half a heart when dealing damage. Increases by 0.1% every time this card is selected.", "common", 
			preload("res://Sprites/healing (1).png"), true, 1.0, {"modifies_player_stats": true, "lifesteal_chance": 0.05 * Global.elite_room}) # change this to 1 for the demo mayhaps
	]
	
	for card in card_pool:
		card["weight"] = CARD_BASE_WEIGHTS[card["rarity"]]
		card_skip_counts[card["card_name"]] = 0

func create_card(card_name: String, description: String, rarity: String, icon: Texture2D, can_repeat: bool, weight: float, effect: Dictionary) -> Dictionary:
	return {
		"card_name": card_name,
		"description": description,
		"rarity": rarity,
		"icon": icon,
		"can_repeat": can_repeat,
		"weight": weight,
		"modifies_player_stats": effect.has("modifies_player_stats"),
		"modifies_gun_stats": effect.has("modifies_gun_stats"),
		"effect_data": effect
	}

func get_random_rewards():
	var available_cards = card_pool.duplicate(true)
	var selected_cards = []
	
	while selected_cards.size() < 3 and available_cards.size() > 0:
		var total_weight = 0
		for card in available_cards:
			total_weight += card["weight"]

		var roll = randf() * total_weight
		var accumulated_weight = 0

		for card in available_cards:
			accumulated_weight += card["weight"]
			if roll <= accumulated_weight:
				selected_cards.append(card)
				available_cards.erase(card)
				break  

	return selected_cards

func adjust_weights_after_selection(selected_card_name):
	for card in card_pool:
		if card["card_name"] == selected_card_name:
			if card["rarity"] == "medium":
				card["weight"] = 0  
			elif card["rarity"] == "rare":
				card["weight"] = max(1, card["weight"] - 1)  # slightly decrease chance after selection
		else:
			if card["rarity"] == "rare":
				card_skip_counts[card["card_name"]] += 1
				card["weight"] += card_skip_counts[card["card_name"]]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func decrementEnemyCount():
	enemyCount -= 1
	print("Enemies Remaining: ", enemyCount)

func incrementEnemyCount():
	enemyCount += 1
	print("Enemies Remaining: ", enemyCount)

func _game_started():
	enemyCount = 0
	player_stats.print_all_stats()
	all_gun_stats.print_all_stats()
	initialize_card_pool()
	tutorial = false
	numLevelsComplete += 1
	if numLevelsComplete == 1:
		active_weapons.append("flamethrower")
	elif numLevelsComplete == 2:
		active_weapons.append("rpg")
	num_enemies_defeated = 0
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	print(playerHealth, " playerHealth, Global ")
	
func _new_game_started():
	print("checking when newGameStarted is emitted, global")
	player_stats.reset_to_defaults()
	player_stats.print_all_stats()
	all_gun_stats.reset_to_defaults()
	all_gun_stats.print_all_stats()
	newGame = false
	enemyCount = 0
	num_enemies_defeated = 0
	numLevelsComplete = 0
	active_weapons = ["AKorn47"]
	if numResets == 0:
		tutorial = true
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	playerHealth = playerHealthNode.player_max_health + player_stats.additional_max_health

func _boss_level_started():
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	player_stats.print_all_stats()
	all_gun_stats.print_all_stats()
	print("player instantiated!")
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
func get_enemy_count() -> int:
	return Global.enemyCount
	
