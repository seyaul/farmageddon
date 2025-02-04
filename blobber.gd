extends Node

@export var move_frequency: int = 1
@export var bones_per_move: int = 10
@export var speed: float = 1500
var parent: SoftBody2D
var time: int

func _ready() -> void:
	parent = get_parent()
func _physics_process(delta: float) -> void:
	time += 1
	var mouse_position := parent.get_global_mouse_position()
	#parent.global_position = mouse_position
	var children = parent.get_children().filter(func(node): return node is RigidBody2D)
	if time % move_frequency == 0:
		for i in range(0, bones_per_move):
			var j = randi_range(0, children.size() - 1)
			var child = children[j]
			child.apply_central_impulse((mouse_position - child.global_position).normalized() * speed)
