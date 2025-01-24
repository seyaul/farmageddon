extends RigidBody2D

@export var rope: PackedScene
@export var num_tentacles: int
@export var tentacle_spread: float
@export_range(0,1)
var tentacle_frequency: float
@export var tentacle_strength: float


var tentacles: Array[Rope]
var ray: RayCast2D
var i: int = 0
func _ready() -> void:
	tentacles_factory()
	ray = get_node("RayCast2D")
	
func _physics_process(delta: float) -> void:
	var interval = randf_range(0, 1)
	if interval <= tentacle_frequency:
		shoot_tentacles()

func tentacles_factory() -> void:
	for i in range(num_tentacles):
		var tentacle: Rope = rope.instantiate()
		tentacle.start = self
		get_tree().current_scene.add_child.call_deferred(tentacle)
		tentacles.append(tentacle)
		
func shoot_tentacles() -> void:
	ray.rotation_degrees = randf_range(-tentacle_spread/2, tentacle_spread/2)
	var point: Vector2 = ray.get_collision_point()
	tentacles[i].set_last(point)
	i = (i + 1) % num_tentacles
	apply_central_impulse((point - global_position).normalized() * tentacle_strength)
