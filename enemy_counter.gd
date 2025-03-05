extends Control

@onready var enemy_label = $EnemyLabel

func _ready():
	# Initialize enemy count
	update_enemy_count(Global.enemyCount)

# Function to update the displayed count
func update_enemy_count(count: int):
	enemy_label.text = "Enemies: " + str(count)
