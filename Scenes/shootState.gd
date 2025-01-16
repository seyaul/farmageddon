extends State

@export var time_shooting: int
var enemy: CharacterBody2D
var time: int

func Enter():
	time = 0
	enemy = get_parent().get_parent()
	
func Update(delta: float):
	time += 1
	enemy.emit_signal("shoot", "hold")
	enemy.emit_signal("shoot", "tap")
	if time >= time_shooting:
		emit_signal("state_transition", self, "Follow")

func Exit():
	time = 0
