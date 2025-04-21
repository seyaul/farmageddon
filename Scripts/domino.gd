extends Node
class_name Domino

@export var domino: PackedScene
@export var gap: float
@export var num_dominos: int
@export var cascade_rate: int = 1
var parent: Node2D
var time: int = 0
var curr_domino: int
func _ready() -> void:
	parent = get_parent()

func _physics_process(delta: float) -> void:
	time += 1
	if time % cascade_rate == 0:
		spawn_domino()
		
func spawn_domino():
	if curr_domino < num_dominos:
		var next_domino: AnimatableBody2D = domino.instantiate()
		next_domino.init(1)
		next_domino.rotation_degrees = parent.rotation_degrees
		next_domino.global_position = parent.global_position + Vector2(-1, 0).rotated(parent.global_rotation) * gap * curr_domino
		get_tree().current_scene.call_deferred("add_child", next_domino)
		curr_domino += 1
