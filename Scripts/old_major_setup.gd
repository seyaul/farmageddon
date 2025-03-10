extends Node2D

var player_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_instance = Global.playerInstance
	add_child(player_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
