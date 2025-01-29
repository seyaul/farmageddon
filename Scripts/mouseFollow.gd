extends Node

var parent: Node2D

func _ready() -> void:
	parent = get_parent()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var mouse_position := parent.get_global_mouse_position()
	parent.position = mouse_position
