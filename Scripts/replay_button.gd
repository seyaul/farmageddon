extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	GameState.player_died = true
	get_tree().change_scene_to_file("res://Scenes/Map.tscn")
	Global.enemyCount = 0
	Global.newGame = true
	Global.numLevelsComplete = 0
	Global.numResets += 1
