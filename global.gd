extends Node

var enemyCount: int
var numRuns : int
var playerHealth : int
var player_scene = preload("res://Scenes/player.tscn")
var playerInstance : CharacterBody2D
var playerHealthNode : Node
var playerCurrHealth : float
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
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	playerHealth = playerHealthNode.player_max_health
	Global.connect("gameStarted", Callable(self, "_game_started"))
	Global.connect("newGameStarted", Callable(self, "_new_game_started"))
	#emit_signal("newGameStarted")
	pass # Replace with function body.


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
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
func get_enemy_count() -> int:
	return Global.enemyCount
	
