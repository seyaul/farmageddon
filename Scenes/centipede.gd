extends Node2D

signal shoot

@export var target: Node2D

func _physics_process(delta: float) -> void:
	make_head_follow_target()
	emit_signal("shoot", "tap", delta)


func make_head_follow_target() -> void:
	global_position = target.global_position
	look_at(target.global_position)
