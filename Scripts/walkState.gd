extends State
class_name WalkState

signal set_prev_movement_vector

@export var speed : float = 200  # Speed in pixels per second
var character: CharacterBody2D
var mc = Node

# Called when the node enters the scene tree for the first time.
func Enter():
	character = get_parent().get_parent()
	mc = get_parent()
	
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

	if direction.x == 1:
		mc.animation.play("rightFacingWalk")
	elif direction.x == -1:
		mc.animation.play("leftFacingWalk")
	elif direction.y == 1:
		mc.animation.play("frontFacingWalk")
	elif direction.y == -1:
		mc.animation.play("backFacingWalk")
	character.move_and_slide()
	
	if direction != Vector2.ZERO:
		emit_signal("set_prev_movement_vector", self, direction)

	character.velocity = direction.normalized() * speed 
	character.move_and_slide()
	
	if Input.is_action_just_pressed("dash"):
		emit_signal("state_transition", self, "Dash")
	elif direction == Vector2.ZERO:
		emit_signal("state_transition", self, "Idle")
	
		

func Exit():
	pass
