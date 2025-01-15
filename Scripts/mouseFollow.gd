extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	position = mouse_position
