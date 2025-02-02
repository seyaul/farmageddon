extends Node

var enemyCount: int
var numRuns : int
var playerHealth : int
var player_scene = preload("res://Scenes/player.tscn")
var playerInstance : CharacterBody2D
var playerHealthNode : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	numRuns = 0
	enemyCount = 0
	playerInstance = player_scene.instantiate()
	playerHealthNode = playerInstance.get_node("./Health")
	playerHealth = playerHealthNode.max_health
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
