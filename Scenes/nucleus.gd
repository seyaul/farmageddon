extends Node2D

@export var rope: PackedScene
@export var num_tentacles: int

var tentacles: Array[Rope]
var rays: Array[RayCast2D]

func _ready() -> void:
	tentacles_factory()
	rays_factory()
	
func _physics_process(delta: float) -> void:
	make_head_follow_mouse()
	shoot_tentacles()

# TODO: Refactor mousefollower to replace this.
func make_head_follow_mouse() -> void:
	var mouse_position := get_global_mouse_position()
	position = mouse_position
	look_at(mouse_position)

func tentacles_factory() -> void:
	for i in range(num_tentacles):
		var tentacle: Rope = rope.instantiate()
		tentacle.start = self
		get_tree().current_scene.add_child.call_deferred(tentacle)
		tentacles.append(tentacle)

func rays_factory() -> void:
	for i in range(num_tentacles):
		var ray: RayCast2D = RayCast2D.new()
		add_child.call_deferred(ray)
		ray.target_position = Vector2(1000, 0)
		rays.append(ray)
		
func shoot_tentacles() -> void:
	for i in range(num_tentacles):
		var point: Vector2 = rays[i].get_collision_point()
		tentacles[i].set_last(point)
