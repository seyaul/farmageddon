extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	GameState.player_died = true
	get_tree().change_scene_to_file("res://Scenes/Map.tscn")
	Global.enemyCount = 0
	Global.tutorial = false
	Global.numLevelsComplete = 0
	Global.newGame = true
	Global.numResets += 1
