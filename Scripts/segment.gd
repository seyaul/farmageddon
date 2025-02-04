extends Node2D

signal shoot

var time: int

func _physics_process(delta: float) -> void:
	time += 1
	if time % 10 == 0:
		emit_signal("shoot", "tap", delta)
