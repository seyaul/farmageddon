extends Node
class_name FiniteStateMachine


@export var initial_state: State
@export var animation: AnimatedSprite2D
var states: Dictionary = {}
var current_state: State
var previous_move_vector: Vector2
var parent: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	if parent.is_in_group("mobs"):
		parent.knocked_back.connect(set_knockback_vector)
		parent.stunned.connect(_handle_stunned)
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
		if child is WalkState:
			child.set_prev_movement_vector.connect(set_previous_move_vector)

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

func set_previous_move_vector(source_state: State, movement_vector: Vector2):
	if source_state.name != "Walk":
		print("error: set_previous_move_vector should only be called on signal from the walk state")
		return
	previous_move_vector = movement_vector

func set_knockback_vector(force: Vector2):
	for child in get_children():
		if child is KnockedBackState:
			child.knockback_velocity = force
	change_state(current_state, "KnockedBack")

func _handle_stunned():
	change_state(current_state, "Stunned")
