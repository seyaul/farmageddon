extends State


var enemy: CharacterBody2D

func Enter():
	enemy = get_parent().get_parent()
	
func Update(delta: float):
	enemy.emit_signal("shoot", "hold")
	enemy.emit_signal("shoot", "tap")

func Exit():
	pass
