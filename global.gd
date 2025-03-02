extends Node

var enemyCount: int
var numRuns : int = 0
var playerHealth : int
var playerGold : int
var playerExp : int
var player_scene = preload("res://Scenes/player.tscn")
var player_stats: PlayerStats
var all_gun_stats: AllGunStats
var card_pool: Array = [] 
var weight_adjustments: Dictionary = {} 
const CARD_BASE_WEIGHTS = {
	"common": 10, 
	"medium": 6,   
	"rare": 2      
} 
var card_skip_counts = {}
var playerInstance : CharacterBody2D
var playerHealthNode : Node
var playerCurrHealth : float
var tutorial : bool = true
signal campfire_selected

# WIP variables
var newGame : bool = true

# To be implemented
var powerUps : Array
var stats : Array
var weapons : Array


signal gameStarted 
signal newGameStarted

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
	playerHealth = playerHealthNode.player_max_health
	playerGold = 0
	playerExp = 0
	Global.connect("gameStarted", Callable(self, "_game_started"))
	Global.connect("newGameStarted", Callable(self, "_new_game_started"))
	#emit_signal("newGameStarted")
	pass # Replace with function body.

func initialize_card_pool():
	# weights/rarities subject to change
	card_pool = [
		create_card("Max Health Boost", "Increases max health by 10.", "common", 
			preload("res://Sprites/healing (1).png"), false, 1.0, {"modifies_player_stats": true, "additional_max_health": 10}),
		create_card("Speed Boost", "Increases movement speed by 1.", "medium", 
			preload("res://Sprites/gold (1).png"), false, 1.0, {"modifies_player_stats": true, "additional_speed": 1}), # probs shld be common
		create_card("Cooldown Reduction", "Reduces weapon cooldown time by 10%.", "common", 
			preload("res://Sprites/xp (1).png"), true, 1.0, {"modifies_gun_stats": true, "cooldown_speed_modifier": 0.9}),
		create_card("Fire Rate Buff", "Increases fire rate by 15%.", "common", 
			preload("res://Sprites/xp (1).png"), true, 1.0, {"modifies_gun_stats": true, "fire_rate_modifier": 1.15}),
		create_card("Lifesteal Ability", "Chance to regain health when dealing damage.", "rare", 
			preload("res://Sprites/healing (1).png"), true, 1.0, {"modifies_player_stats": true, "lifesteal_chance": 5})
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
	numRuns = 0
	enemyCount = 0
	tutorial = false
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	playerHealth = playerCurrHealth
	print(playerHealth, " current health, Global ")
	
func _new_game_started():
	print("checking when newGameStarted is emitted, global")
	newGame = false
	enemyCount = 0
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	playerHealth = playerHealthNode.player_max_health
	print(playerHealth, "Player health in global.gd")
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
func get_enemy_count() -> int:
	return Global.enemyCount
	
