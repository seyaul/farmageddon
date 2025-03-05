extends State

@export var target: Node2D
var fsm: FiniteStateMachine
var followPathState : State

func Enter():
	# Merely setting up path before making the enemy follow the path.
	followPathState.attach_position_to = target
	followPathState.backwards = true
	
	
func Update(_delta: float):
	# Immediately exit state.
	emit_signal("state_transition", self, "FollowPath")

func Exit():
	pass

func _ready() -> void:
	fsm = get_parent()
	followPathState = fsm.get_node("FollowPath")
	
