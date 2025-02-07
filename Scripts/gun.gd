extends Sprite2D

#NOTE: Interesting concept, really slow projectiles act as a trail of bullets left behind.
# TODO: Refactor to determine bullet type dynamically.
@export_enum("Discrete", "Continuous")
var fire_type: String = "Discrete"
@export var bullet: PackedScene
@export var projectile_speed: float = 300
@export var automatic: bool = false
@export var fire_rate: int = 20
@export var spread: float = 0
@export var bullets_per_fire: int = 1

# TODO: Replace with timer?
var id: int = 0
var time: int = 0
var counting: bool = false
var beam: Line2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().shoot.connect(handle_signal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if counting:
		time += 1
	
func handle_signal(gun_id: int, action: String, delta: float) -> void:
	if gun_id == id:
		if not automatic && action == "tap":
			fire(delta)
		elif automatic && action == "hold": 
			counting = true
			if time % fire_rate == 0 and is_instance_valid(bullet):
				fire(delta)
		elif automatic && action == "end":
			if is_instance_valid(beam):
				beam.queue_free()
			counting = false
			time = 0

func fire(delta: float) -> void:
	if fire_type == "Discrete":
		for i in range(bullets_per_fire):
			var projectile: AnimatableBody2D = bullet.instantiate()
			projectile.position = global_position
			# TODO:Refactor this
			projectile.rotation_degrees = (global_rotation_degrees - 90) + randf_range(-1 * spread, spread) 
			var direction = Vector2(cos(projectile.rotation), sin(projectile.rotation)).normalized()
			projectile.constant_linear_velocity = direction * projectile_speed * delta
			get_tree().current_scene.add_child(projectile)
	elif fire_type == "Continuous":
		if not is_instance_valid(beam):
			beam = bullet.instantiate()
			beam.rotation_degrees = 0 
			# TODO: Refactor this
			add_child(beam)
		else:
			beam.apply_damage()
