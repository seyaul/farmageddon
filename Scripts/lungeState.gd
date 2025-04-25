extends State

# These signals are used to temporarily disble the rotation of the bull during a lunge
signal disable_targeter
signal enable_targeter
signal play_pre_lunge_animation
# TODO: possibly refactor dashstate script to replace since they are similar.
@export var phase_on_lunge: bool = false
@export var max_distance: float = 500
@export var lunge_speed: float = 5 
# The enemy will exit lunge state after timout seconds
@export var timeout: float = 4
@export var lunge_prep_delay: float = 1
# TODO: Replace with timer.
var enemy: CharacterBody2D
var initial_position: Vector2
var target_position: Vector2
var lunge_timer: Timer
var prep_phase_timer: Timer
var in_prep_phase: bool = false
var in_move_phase: bool = false
var next_lunge_direction: Vector2
 
func _ready():
	lunge_timer = Timer.new()
	lunge_timer.wait_time = timeout
	lunge_timer.timeout.connect(_on_lunge_timeout)
	prep_phase_timer = Timer.new()
	prep_phase_timer.wait_time = lunge_prep_delay
	prep_phase_timer.timeout.connect(exit_prep_phase)
	add_child(lunge_timer)
	add_child(prep_phase_timer)


func Enter():
	enemy = get_parent().get_parent()
	initial_position = enemy.global_position
	target_position = enemy.global_position + enemy.velocity.normalized() * max_distance
	lunge_timer.start()
	emit_signal("disable_targeter")
	
func Update(_delta: float):
	if in_prep_phase:
		return
	if round(enemy.global_position) != round(target_position) and \
		enemy.global_position.distance_to(initial_position) < max_distance:
		if in_move_phase:
			enemy.move_and_slide()
		else:
			var direction = (target_position - enemy.global_position).normalized()
			enter_prep_phase(direction)
		return
	else:
		emit_signal("state_transition", self, "Follow")

func Exit():
	in_prep_phase = false
	in_move_phase = false
	emit_signal("enable_targeter")
	phase(false)
	lunge_timer.stop()
	prep_phase_timer.stop()

func phase(action: bool) -> void:
	enemy.set_collision_layer_value(3, not action)
	enemy.set_collision_mask_value(1, not action)
	
# This is signaled on timeout to exit the lunge state
func _on_lunge_timeout():
	emit_signal("state_transition", self, "Follow")

func exit_prep_phase():
	if has_node("../../attacking"):
		$"../../attacking".play()
	in_prep_phase = false
	in_move_phase = true
	if phase_on_lunge:
		phase(true)
	enemy.velocity = next_lunge_direction * lunge_speed

func enter_prep_phase(direction: Vector2):
	#print("entering prep phase")
	emit_signal("play_pre_lunge_animation")
	in_prep_phase = true
	next_lunge_direction = direction
	prep_phase_timer.start()
