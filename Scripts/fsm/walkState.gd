extends State
class_name WalkState

signal set_prev_movement_vector

@export var speed : float = 300  # Speed in pixels per second
var actual_speed
var local_speed_modifier: float = 1
var character: CharacterBody2D
var mc = Node

func Enter():
	character = get_parent().get_parent()
	mc = get_parent()
	actual_speed = ((speed + Global.player_stats.additional_speed) * Global.player_stats.speed_modifier)
	
func Update(_delta: float):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		character.velocity = direction * actual_speed * local_speed_modifier
		character.rotation = direction.angle()  # Rotate in movement direction
		# emit_signal("set_prev_movement_vector", self, direction)
	else:
		character.velocity = Vector2.ZERO
	
	character.move_and_slide()

	# State transitions
	if Input.is_action_just_pressed("dash"):
		emit_signal("state_transition", self, "Dash")
	elif direction == Vector2.ZERO:
		emit_signal("state_transition", self, "Idle")

func modify_speed(speed_modifier: float):
	local_speed_modifier = speed_modifier

func reset_speed_modifier():
	local_speed_modifier = 1

func Exit():
	pass
