extends Sprite2D

# baseGun is the base class from which all guns that the player uses are inherited
class_name baseGun

# signal used to decrease the number of bullets in the mag in the player node
signal bullet_fired

# signal used to set the max ammo for the parent player node
signal set_max_ammo

# signals for continuous weapons
signal continuous_started
#signal continuous_ended

#NOTE: Interesting concept, really slow projectiles act as a trail of bullets left behind.
# TODO: Refactor to determine bullet type dynamically.
@export_enum("Discrete", "Continuous")
var fire_type: String = "Discrete"
@export var bullet: PackedScene
var emission_point_offset: Vector2 = Vector2(0, -115)

# gun stats prior to modifiers
@export var projectile_speed: float
@export var base_fire_rate: int
@export var spread: float = 0
@export var bullets_per_fire: int
@export var base_heat_increase_rate: float 
@export var fire_overhead : float

# actual gun stats
var actual_fire_rate: int
var actual_heat_increase_rate: float

@export var automatic: bool 
@export var damage: int
var continuous_active : bool
var active_shooting: bool = true
var audio_player: AudioStreamPlayer2D
var muzzle_particles: CPUParticles2D
var player: CharacterBody2D
var time_between_shots : float
@onready var overheatSound: AudioStreamPlayer = $overheatSound

# TODO: Replace with timer?
var time: int = 0
var counting: bool = false
var beam: Line2D
var discrete_shot_cd_fulfilled : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent()
	if name == "AKorn47":
		bullets_per_fire += Global.all_gun_stats.akorn47_additional_bullets_per_fire
	player.shoot.connect(handle_signal)
	player.disable_shooting.connect(disable_shooting_handler)
	player.enable_shooting.connect(enable_shooting_handler)
	player.continuous_started.connect(handle_continuous_start)
	player.continuous_ended.connect(handle_continuous_ended)
	$discrGunTimer.timeout.connect(handle_dgcd)
	# initialize actual gun stats using config
	actual_fire_rate = int(base_fire_rate * Global.all_gun_stats.fire_rate_modifier)
	print(actual_fire_rate, " actual fire rate")
	actual_heat_increase_rate = base_heat_increase_rate * Global.all_gun_stats.cooldown_speed_modifier
	time_between_shots = 10.0 / actual_fire_rate
	$discrGunTimer.wait_time = time_between_shots
	print(time_between_shots, " time between shots")
	audio_player = $ShootingSound
	muzzle_particles = $MuzzleParticles

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if counting:
		time += 1
	if fire_type == "continuous" and continuous_active:
		emit_signal("continuous_started", actual_heat_increase_rate)
	elif fire_type == "continuous" and !continuous_active:
		pass
	
func handle_signal(action: String, delta) -> void:
	if not automatic and action == "tap":
		#print("hello is this thing on")
		if !discrete_shot_cd_fulfilled:
			return
		fire(delta)
		discrete_shot_cd_fulfilled = false  # Prevent shooting again too soon
		$discrGunTimer.start()  # Start cooldown timer
	if automatic && action == "hold":
		if !discrete_shot_cd_fulfilled:
			return
		discrete_shot_cd_fulfilled = false 
		$discrGunTimer.start()
		if is_instance_valid(bullet):
			fire(delta)
	elif automatic && action == "end":
		if is_instance_valid(beam):
			beam.queue_free()
		counting = false
		time = 0

func fire(delta: float) -> void:
	muzzle_particles.emitting = true
	#print(active_shooting, " ", automatic)
	if !active_shooting:
		overheatSound.stop()
		overheatSound.play()
		return
	# Get the mouse position in global coordinates
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - player.global_position).normalized()
	var base_rotation = direction_to_mouse.angle()

	if fire_type == "Discrete":
		
		for i in range(bullets_per_fire):
			if audio_player:
				audio_player.pitch_scale = randf_range(0.9, 1.1)
				audio_player.play()
			var projectile: AnimatableBody2D = bullet.instantiate()
			projectile.init(20)
			projectile.position = global_position

			var spread_angle = randf_range(-1 * spread, spread)
			projectile.rotation = base_rotation + deg_to_rad(spread_angle)

			# Calculate the direction of the projectile
			var direction = Vector2(cos(projectile.rotation), sin(projectile.rotation)).normalized()
			projectile.constant_linear_velocity = direction * projectile_speed * delta

			# Add projectile to the scene
			get_tree().current_scene.add_child(projectile)

			# Emit signal to indicate bullet has been fired
			emit_signal("bullet_fired", actual_heat_increase_rate)

	elif fire_type == "Continuous":
		if not is_instance_valid(beam):
			beam = bullet.instantiate()
			beam.rotation = base_rotation
			add_child(beam)
		else:
			beam.apply_damage()
			# can't figure out continuous heat increase within gun. I know how to do it within player.
			#emit_signal("bullet_fired", heat_increase_rate)

func disable_shooting_handler():
	active_shooting = false

func enable_shooting_handler():
	active_shooting = true
	
func handle_continuous_start():
	continuous_active = true
	print("continuous shooting started, ", continuous_active)

func handle_continuous_ended():
	continuous_active = false
	print("continuous shooting ended ", continuous_active)
	
func handle_dgcd():
	discrete_shot_cd_fulfilled = true
	$discrGunTimer.stop()
	
