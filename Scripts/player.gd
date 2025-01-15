extends CharacterBody2D

signal shoot
signal melee
signal shockwave

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		emit_signal("shoot", "tap")
	elif Input.is_action_pressed("shoot"):
		emit_signal("shoot", "hold")
	elif Input.is_action_just_released("shoot"):
		emit_signal("shoot", "end")
		
	if Input.is_action_just_pressed("melee"):
		emit_signal("melee")
	
	if Input.is_action_just_pressed("shockwave"):
		emit_signal("shockwave")
		
	
