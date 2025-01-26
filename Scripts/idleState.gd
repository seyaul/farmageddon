extends State
class_name IdleState

var character: CharacterBody2D
var mc: Node

func Enter():
	character = get_parent().get_parent()
	mc = get_parent()
	
func Update(_delta: float):
	if Input.get_vector("move_left", "move_right", "move_up", "move_down"):
		emit_signal("state_transition", self, "Walk")
	elif Input.is_action_just_pressed("dash"):
		emit_signal("state_transition", self, "Dash")
	else:
		var pmv = mc.previous_move_vector
		if pmv.x == 1:
			mc.animation.play("rightFacingIdle")
		elif pmv.x == -1:
			mc.animation.play("leftFacingIdle")
		elif pmv.y == 1:
			mc.animation.play("frontFacingIdle")
		elif pmv.y == -1:
			mc.animation.play("backFacingIdle")
		character.move_and_slide()
func Exit():
	pass
