extends State

@export var audio: AudioStreamPlayer2D
@export var trigger_attack_with_state: Dictionary
var mfsm: FiniteStateMachine

func Enter():
	audio.play()
	
func Update(_delta: float):
	if is_instance_valid(mfsm.current_state) and \
	trigger_attack_with_state.has(mfsm.current_state.name):
		#print(trigger_attack_with_state[mfsm.current_state.name])
		emit_signal("state_transition", self, trigger_attack_with_state[mfsm.current_state.name])

func Exit():
	pass
	
func _ready() -> void:
	mfsm = get_parent().get_parent().get_node("EMovementController")
	
