extends Sprite2D

# baseGun is the base class from which all guns that the player uses are inherited
class_name baseGun

# signal used to decrease the number of bullets in the mag in the player node
signal bullet_fired
# signal used to set the max ammo for the parent player node
signal set_max_ammo

#NOTE: Interesting concept, really slow projectiles act as a trail of bullets left behind.
# TODO: Refactor to determine bullet type dynamically.
@export_enum("Discrete", "Continuous")
var fire_type: String = "Discrete"
@export var bullet: PackedScene
@export var projectile_speed: float = 400 
@export var automatic: bool = false
@export var fire_rate: int = 20
@export var spread: float = 0
@export var bullets_per_fire: int = 1
@export var magazine_size: int = 10
var active_shooting: bool = true
var audio_player: AudioStreamPlayer2D

# TODO: Replace with timer?
var time: int = 0
var counting: bool = false
var beam: Line2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().shoot.connect(handle_signal)
	get_parent().disable_shooting.connect(disable_shooting_handler)
	get_parent().enable_shooting.connect(enable_shooting_handler)
	get_parent().max_ammo = magazine_size
	get_parent().ammo = magazine_size
	audio_player = $ShootingSound

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if counting:
		time += 1
	
func handle_signal(action: String, delta) -> void:
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
	if !active_shooting:
		return
	# Get the mouse position in global coordinates
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - global_position).normalized()
	var base_rotation = direction_to_mouse.angle()

	if fire_type == "Discrete":
		for i in range(bullets_per_fire):
			if audio_player:
				audio_player.pitch_scale = randf_range(0.9, 1.1)
				audio_player.play()
			var projectile: AnimatableBody2D = bullet.instantiate()
			projectile.position = global_position

			var spread_angle = randf_range(-1 * spread, spread)
			projectile.rotation = base_rotation + deg_to_rad(spread_angle)

			# Calculate the direction of the projectile
			var direction = Vector2(cos(projectile.rotation), sin(projectile.rotation)).normalized()
			projectile.constant_linear_velocity = direction * projectile_speed * delta

			# Add projectile to the scene
			get_tree().current_scene.add_child(projectile)

			# Emit signal to reduce ammo
			emit_signal("bullet_fired")

	elif fire_type == "Continuous":
		if not is_instance_valid(beam):
			beam = bullet.instantiate()
			beam.rotation = base_rotation
			add_child(beam)
		else:
			beam.apply_damage()

func disable_shooting_handler():
	active_shooting = false

func enable_shooting_handler():
	active_shooting = true
