extends Node

var parent: SoftBody2D

func _ready() -> void:
	parent = get_parent()
func _physics_process(delta: float) -> void:
	var mouse_position := parent.get_global_mouse_position()
	parent.global_position = mouse_position
	#var children = parent.get_children().filter(func(node): return node is RigidBody2D)
	#for i in range(0, 1):
	#	var child = children[i]
	#	child.apply_central_impulse((parent.global_position - child.global_position).normalized() * 50)
