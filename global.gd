extends Node

var enemyCount: int
var numRuns : int
var playerHealht : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	numRuns = 0
	enemyCount = 0
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
