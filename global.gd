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
var map_tutorial : bool
var num_enemies_defeated : int
var map_tutorial_has_run := false
var elite_room : int = 1
signal campfire_selected

# WIP variables
var newGame : bool = true

# To be implemented
var chosen_buffs : Array
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
	playerHealth = playerMaxHealth + player_stats.additional_max_health_modifier
	
	playerGold = 0
	playerExp = 0
	
	if not is_connected("campfire_selected", Callable(self, "_on_campfire_selected")):
		connect("campfire_selected", Callable(self, "_on_campfire_selected"))
		#print("connected campfire_selected signal")
	
	Global.connect("mob_died", Callable(self, "_on_mob_died"))
	Global.connect("gameStarted", Callable(self, "_game_started"))
	Global.connect("newGameStarted", Callable(self, "_new_game_started"))
	Global.connect("bossLevelStarted", Callable(self, "_boss_level_started"))
	#emit_signal("newGameStarted")
	pass # Replace with function body.

func _on_campfire_selected():
	Global.playerHealth = playerMaxHealth + player_stats.additional_max_health_modifier
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
	#print("LIFESTEAL SHOWING AHHH")
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
	if Global.playerHealth >= Global.playerHealthNode.player_max_health + Global.player_stats.additional_max_health_modifier:
		return

	var lifesteal_roll = randf()
	if lifesteal_roll <= Global.player_stats.lifesteal_chance_modifier:
		playerHealthNode.heal(1)
		show_lifesteal_popup()
		#print("lifesteal activated yippee!")
	else:
		pass
		#print("no lifesteal for u")

func initialize_card_pool():
	# weights/rarities subject to change
	card_pool = [
		create_card("Max Health Boost", preload("res://Sprites/new cards/card descs/max health desc.PNG"), "rare", 
			preload("res://Sprites/new cards/max health long.png"), false, 1.0, {"modifies_player_stats": true, "additional_max_health_modifier": 10}),
		 create_card("Speed Boost", preload("res://Sprites/new cards/card descs/speed desc.PNG"), "medium", 
			 preload("res://Sprites/new cards/speed long.png"), false, 1.0, {"modifies_player_stats": true, "speed_modifier": 0.3 * Global.elite_room}), # probs shld be common
		 create_card("Heating Rate Reduction", preload("res://Sprites/new cards/card descs/heating rate desc.PNG"), "common", 
			 preload("res://Sprites/new cards/heat rate long.png"), true, 1.0, {"modifies_gun_stats": true, "cooldown_speed_modifier": 0.8 / Global.elite_room}),
		 create_card("Fire Rate Buff", preload("res://Sprites/new cards/card descs/fire rate desc.PNG"), "common", 
			 preload("res://Sprites/new cards/fire rate long.png"), true, 1.0, {"modifies_gun_stats": true, "fire_rate_modifier": 1 + 0.15 * Global.elite_room}),
		 create_card("Lifesteal Ability", preload("res://Sprites/new cards/card descs/lifesteal desc.PNG"), "common", 
			 preload("res://Sprites/new cards/life steal long.png"), true, 1.0, {"modifies_player_stats": true, "lifesteal_chance_modifier": 0.05 * Global.elite_room}), 
			 create_card("Multi-Shot Upgrade", preload("res://Sprites/new cards/card descs/dual fire desc.PNG"), "rare",
			 preload("res://Sprites/new cards/dual fire rate.png"), true, 1.0, {"modifies_gun_stats": true, "akorn47_additional_bullets_per_fire": 1})
	]
	
	for card in card_pool:
		card["weight"] = CARD_BASE_WEIGHTS[card["rarity"]]
		card_skip_counts[card["card_name"]] = 0

func create_card(card_name: String, description: Texture2D, rarity: String, icon: Texture2D, can_repeat: bool, weight: float, effect: Dictionary) -> Dictionary:
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
	#print("Enemies Remaining: ", enemyCount)

func incrementEnemyCount():
	enemyCount += 1
	#print("Enemies Remaining: ", enemyCount)

func _game_started():
	enemyCount = 0
	player_stats.print_all_stats()
	all_gun_stats.print_all_stats()
	initialize_card_pool()
	tutorial = false
	map_tutorial = false
	numLevelsComplete += 1
	if numLevelsComplete == 1:
		active_weapons = ["flamethrower", "AKorn47"]
	elif numLevelsComplete == 2:
		active_weapons = ["rpg", "flamethrower", "AKorn47"]
	num_enemies_defeated = 0
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	#print(playerHealth, " playerHealth, Global ")
	
func _new_game_started():
	#print("checking when newGameStarted is emitted, global")
	chosen_buffs = []
	player_stats.reset_to_defaults()
	player_stats.print_all_stats()
	all_gun_stats.reset_to_defaults()
	all_gun_stats.print_all_stats()
	newGame = false
	map_tutorial = true
	enemyCount = 0
	num_enemies_defeated = 0
	numLevelsComplete = 0
	active_weapons = ["AKorn47"]
	if numResets == 0:
		tutorial = true
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	playerHealth = playerHealthNode.player_max_health + player_stats.additional_max_health_modifier

func _boss_level_started():
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	player_stats.print_all_stats()
	all_gun_stats.print_all_stats()
	#print("player instantiated!")
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
func get_enemy_count() -> int:
	return Global.enemyCount
	
func get_chosen_buffs() -> Array:
	return Global.chosen_buffs
