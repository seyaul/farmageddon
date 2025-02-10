extends Node

@export var fragment: PackedScene
@export var projectile_speed: float = 300
@export_enum("Random", "Even")
var fragment_pattern: String = "Random"
@export var spread: float = 0
@export var num_bullets: int = 0
var container: Node2D
# TODO: Replace with timer?
var time: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	container = get_parent()

func explode() -> void:
	for i in range(num_bullets):
		var projectile: AnimatableBody2D = fragment.instantiate()
		projectile.position = container.global_position
		# TODO:Refactor the minus 90
		if fragment_pattern == "Random":
			projectile.rotation_degrees = (container.global_rotation_degrees - 90) + randf_range(-1 * spread, spread)
		else:
			projectile.rotation_degrees = (container.global_rotation_degrees - 90) + float(i + 1) / float(num_bullets) * spread
		var direction = Vector2(cos(projectile.rotation), sin(projectile.rotation)).normalized()
		projectile.constant_linear_velocity = direction * projectile_speed
		get_tree().current_scene.call_deferred("add_child", projectile)

func _exit_tree() -> void:
	explode()
