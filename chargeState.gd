extends State
class_name PauseState

signal play_pre_lunge_animation
signal disable_targeter
signal enable_targeter

@export var timeout: int
var time:int

func Enter():
	time = 0
	emit_signal("disable_targeter")
	emit_signal("play_pre_lunge_animation")

func Update(delta):
	time += 1
	if (time >= timeout):
		emit_signal("state_transition", self, "Follow")

func Exit():
	emit_signal("enable_targeter")
