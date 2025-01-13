extends CharacterBody2D

signal shoot

func _physics_process(_delta: float) -> void:
	emit_signal("shoot", "hold")
