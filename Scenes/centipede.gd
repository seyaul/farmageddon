extends CharacterBody2D

signal shoot

func _physics_process(delta: float) -> void:
	emit_signal("shoot", "tap", delta)
