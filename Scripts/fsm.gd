extends Node
class_name FiniteStateMachine


@export var initial_state: State
@export var animation : AnimationPlayer
var states: Dictionary = {}
var current_state: State
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
		
	if initial_state:
		initial_state.Enter()
		current_state  = initial_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func change_state(source_state: State, new_state_name:String):
	#print(source_state, new_state_name)
	if source_state != current_state:
		print("Invalid change_state trying from: " + source_state.name + " but currently in: " + current_state.name)
		return
		
	var new_state: State = states.get(new_state_name.to_lower())
	if not new_state:
		print("New state is empty")
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	current_state = new_state
	

func force_change_state(source_state: State, new_state_name:String):
	var new_state: State = states.get(new_state_name.to_lower())
	if not new_state:
		print(new_state.name + " does not exist in the dictionary of current states")
		return
		
	if current_state == new_state:
		print("State is same, aborting")
		return
	
	# Used to prevent warnings
	if current_state:
		var exit_callable = Callable(current_state, "Exit")
		exit_callable.call_deferred()
		
	new_state.Enter()
	current_state = new_state
