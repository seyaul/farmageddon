extends State

@export var target: Node2D

func Enter():
	var fsm = get_parent()
	var followPathState = fsm.get_node("FollowPath")
	followPathState.attach_position_to = target
	followPathState.backwards = true
	
	
func Update(_delta: float):
	emit_signal("state_transition", self, "Return")

func Exit():
	pass
