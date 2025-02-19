extends State

# These signals are used to temporarily disble the rotation of the bull during a lunge
signal disable_targeter
signal enable_targeter
# TODO: possibly refactor dashstate script to replace since they are similar.
@export var phase_on_lunge: bool = false
@export var max_distance: float = 500
@export var lunge_speed: float = 5 
# The enemy will exit lunge state after timout seconds
@export var timeout: float = 1
# TODO: Replace with timer.
var enemy: CharacterBody2D
var initial_position: Vector2
var target_position: Vector2
var lunge_timer: SceneTreeTimer
 
	
func Enter():
	enemy = get_parent().get_parent()
	initial_position = enemy.global_position
	target_position = enemy.global_position + enemy.velocity.normalized() * max_distance
	lunge_timer = get_tree().create_timer(timeout)
	lunge_timer.timeout.connect(_on_lunge_timeout)
	emit_signal("disable_targeter")
	
func Update(_delta: float):
	if round(enemy.global_position) != round(target_position) and \
		enemy.global_position.distance_to(initial_position) < max_distance:
		if phase_on_lunge:
			phase(true)
		var direction = (target_position - enemy.global_position).normalized()
		enemy.velocity = direction * lunge_speed
		# Use move_and_slide to move and detect collisions
		enemy.move_and_slide()
	else:
		emit_signal("state_transition", self, "Follow")

func Exit():
	emit_signal("enable_targeter")
	phase(false)
	if lunge_timer and lunge_timer.timeout.is_connected(_on_lunge_timeout):
		lunge_timer.timeout.disconnect(_on_lunge_timeout)

func phase(action: bool) -> void:
	enemy.set_collision_layer_value(3, not action)
	enemy.set_collision_mask_value(1, not action)
	
# This is signaled on timeout to exit the lunge state
func _on_lunge_timeout():
	emit_signal("state_transition", self, "Follow")
