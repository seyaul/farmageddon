extends CharacterBody2D

signal shoot
signal melee
signal shockwave

func _ready() -> void:
	var crosshairs = get_node("../Crosshairs")
	$Targeter.target = crosshairs

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		emit_signal("shoot", "tap", delta)
	elif Input.is_action_pressed("shoot"):
		emit_signal("shoot", "hold", delta)
	elif Input.is_action_just_released("shoot"):
		emit_signal("shoot", "end", delta)

	if Input.is_action_just_pressed("melee"):
		emit_signal("melee")
	
	if Input.is_action_just_pressed("shockwave"):
		emit_signal("shockwave")
