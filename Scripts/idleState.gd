extends State
class_name IdleState

var character: CharacterBody2D
var mc: Node

func Enter():
	character = get_parent().get_parent()
	#mc = get_parent()
	
func Update(_delta: float):
	if Input.get_vector("move_left", "move_right", "move_up", "move_down"):
		emit_signal("state_transition", self, "Walk")
	elif Input.is_action_just_pressed("dash"):
		emit_signal("state_transition", self, "Dash")
	else:
		#mc.animation.play("idle")
		#character.velocity = Vector2.ZERO
		character.move_and_slide()
func Exit():
	pass
