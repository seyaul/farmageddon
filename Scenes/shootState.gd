extends State

@export var time_shooting: int
var enemy: CharacterBody2D
var time: int

func Enter():
	time = 0
	enemy = get_parent().get_parent()
	
func Update(delta: float):
	time += 1
	#enemy.emit_signal("shoot", "hold", delta)
	#enemy.emit_signal("shoot", "tap", delta)
	#if time >= time_shooting:
	#	emit_signal("state_transition", self, "Neutral")

func Exit():
	time = 0
