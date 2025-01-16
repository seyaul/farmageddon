extends State

@export var follow_target: Node2D
@export var strafe_angle: float = 90
@export var speed: float = 10000
@export var bias: float = 0.5
@export var max_strafe_distance: float = 200
var enemy: CharacterBody2D
var guide: PathFollow2D
var left_or_right: int
var initial_position: Vector2
var curr_distance: float
func Enter():
	enemy = get_parent().get_parent()
	guide = enemy.get_parent()
	left_or_right = -1 if randf() < bias else 1
	initial_position = enemy.global_position

func Update(delta: float):
	enemy.look_at(follow_target.global_position)

	var strafe: float = left_or_right * deg_to_rad(strafe_angle)
	var dir = Vector2(cos(enemy.global_rotation + strafe), sin(enemy.global_rotation + strafe)).normalized()
	enemy.velocity = dir * speed * delta
	enemy.move_and_slide()
	curr_distance += (enemy.global_position - initial_position).length()
	if curr_distance >= max_strafe_distance:
		emit_signal("state_transition", self, "Follow")
	initial_position = enemy.global_position 
	
func Exit():
	curr_distance = 0
