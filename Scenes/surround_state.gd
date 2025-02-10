extends State

@export var target: Node2D

func Enter():
	# Merely setting up path before making the enemy follow the path.
	var fsm = get_parent()
	var followPathState = fsm.get_node("FollowPath")
	followPathState.attach_position_to = target
	followPathState.backwards = true
	
	
func Update(_delta: float):
	# Immediately exit state.
	emit_signal("state_transition", self, "FollowPath")

func Exit():
	pass
