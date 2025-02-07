extends State
# Intermediary state
# Randomly selects one of the state options to transition into
@export var options: Array[String]

func Enter():
	pass
	
func Update(_delta: float):
	emit_signal("state_transition", self, options[randi() % options.size()])

func Exit():
	pass
