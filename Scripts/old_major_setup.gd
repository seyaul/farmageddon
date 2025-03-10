extends Node2D

var player_instance
var health_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_instance = Global.playerInstance
	add_child(player_instance)
	health_node = $Boss/Health
	print(health_node)
	health_node.you_win.connect(handle_you_win)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_you_win():
	print("Handled")
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
