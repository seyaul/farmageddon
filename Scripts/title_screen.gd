extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var music = get_node("AudioStreamPlayer")
	music.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Map.tscn")
