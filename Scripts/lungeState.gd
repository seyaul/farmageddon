extends State

# TODO: possibly refactor dashstate script to replace since they are similar.
@export var phase_on_lunge: bool = false
@export var max_distance: float = 500
@export var lunge_speed: float = 5 
# TODO: Replace with timer.
var enemy: CharacterBody2D
var initial_position: Vector2
var target_position: Vector2
 
	
func Enter():
	enemy = get_parent().get_parent()
	initial_position = enemy.global_position
	target_position = enemy.global_position + enemy.velocity.normalized() * max_distance
	
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
	phase(false)

func phase(action: bool) -> void:
	enemy.set_collision_layer_value(3, not action)
	enemy.set_collision_mask_value(1, not action)
	
