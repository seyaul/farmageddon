extends State

#TODO: Refactor or make a new state machine stuff.
@export var trigger_attack_with_state: Dictionary
@export var fire_rate: int = 1
var mfsm: FiniteStateMachine

@export_enum("Front", "Left", "Right")
var side_shooting: String

var snake: Snake
var guns: Node
var time: int

func Enter():
	time = 0

func Update(delta: float):
	time += 1
	if guns.guns_connected:
		shoot_guns(delta)


	if is_instance_valid(mfsm.current_state) and \
	trigger_attack_with_state.has(mfsm.current_state.name) and \
	trigger_attack_with_state[mfsm.current_state.name] != name:
		emit_signal("state_transition", self, trigger_attack_with_state[mfsm.current_state.name])
	elif is_instance_valid(mfsm.current_state) and \
	not trigger_attack_with_state.has(mfsm.current_state.name):
		emit_signal("state_transition", self, "Neutral")

func Exit():
	for i in range(0, snake.num_segments, guns.segments_with_gun):
		var segment = snake.segments[i]
		segment.emit_signal("shoot", 0, "end", 0)
		segment.emit_signal("shoot", 1, "end", 0)

func _ready() -> void:
	mfsm = get_parent().get_parent().get_node("EMovementController")
	snake = get_parent().get_parent()
	guns = snake.get_node("Snake_Guns")
	
# TODO: Maybe add parameter values for this?
func shoot_guns(delta: float) -> void:
	print(time % fire_rate, "  ",time, "   ", fire_rate)
	if side_shooting == "Front" and time % fire_rate == 0:
		var segment = snake.segments[0]
		segment.emit_signal("shoot", 0, "hold", delta)
		segment.emit_signal("shoot", 1, "hold", delta)
	var parity: bool = true
	for i in range(1, snake.num_segments, guns.segments_with_gun):
		if parity:
			var segment = snake.segments[i]
			if side_shooting == "Left":
				segment.emit_signal("shoot", 0, "hold", delta)
			elif  side_shooting == "Right":
				segment.emit_signal("shoot", 1, "hold", delta)
		parity = not parity
	
