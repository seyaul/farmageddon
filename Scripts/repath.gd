extends State

@export var follow_path_state: String
@export var guide: PathFollow2D
@export var look_at_player: bool
@export var speed: float = 0.1
@export var snap_distance: float = 0.1

var enemy: CharacterBody2D
var targeter: Node
	
func Enter():
	if targeter && not look_at_player:
		targeter.disabled = true


func Update(delta: float):
	enemy.look_at(guide.global_position)
	var dir = Vector2(cos(enemy.global_rotation), sin(enemy.global_rotation)).normalized()
	enemy.velocity = dir * speed * delta
	enemy.move_and_slide()
	if enemy.global_position.distance_to(guide.global_position) <= snap_distance:
		emit_signal("state_transition", self, follow_path_state)

func Exit():
	enemy.global_position = guide.global_position
	enemy.velocity = Vector2.ZERO
	enemy.rotation_degrees = 0
	if targeter:
		targeter.disabled = false
		
func _ready() -> void:
	enemy = get_parent().get_parent()
	targeter = enemy.get_node("Targeter")
	
