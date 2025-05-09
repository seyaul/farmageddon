extends baseGun

@export var flames_cutoff_delay: float = 0.2
@export var damage_interval: float = 0.05  # Time between damage ticks
@export var flame_damage: float = 3  # Damage per tick

var actual_flame_damage: float
var time_since_last_shot: float = 0
var flames: CPUParticles2D
var damage_timer: Timer
var damage_area: Area2D
var targets = []


func _ready() -> void:
	super._ready()
	

	flames = $CPUParticles2D
	flames.emitting = false
	fire_type = "continuous"
	damage_area = $DamageArea 
	damage_area.body_entered.connect(_on_body_entered)
	damage_area.body_exited.connect(_on_body_exited)

	# Timer to apply damage over time
	damage_timer = Timer.new()
	damage_timer.wait_time = damage_interval
	damage_timer.autostart = false
	damage_timer.one_shot = false
	damage_timer.paused = false
	damage_timer.timeout.connect(apply_damage)
	add_child(damage_timer)

	# Customize weapon-specific properties
	actual_flame_damage = flame_damage * Global.all_gun_stats.flame_damage_modifier
	bullets_per_fire = 1
	spread = 0
	projectile_speed = 30000
	automatic = false

func _process(delta: float) -> void:
	# var mouse_position = get_global_mouse_position()
	# var direction_to_mouse = (mouse_position - global_position).normalized()
	# flames.direction = Vector2(cos(direction_to_mouse.angle()), sin(direction_to_mouse.angle()))
	# damage_area.rotation = direction_to_mouse.angle()
	
	if active_shooting:
		time_since_last_shot += delta
		if time_since_last_shot >= flames_cutoff_delay:
			stop_firing()

func handle_signal(action: String, delta) -> void:
	if action == "hold":
		fire(delta)
	elif action == "end":
		stop_firing()


func fire(delta: float) -> void:
	if !active_shooting:
		stop_firing()
		damage_timer.stop()
		return
	
	start_firing()
	time_since_last_shot = 0

func start_firing() -> void:
	flames.emitting = true
	damage_area.set_collision_mask_value(3, true)
	damage_area.set_collision_mask_value(4, true)
	if !audio_player.playing:
		audio_player.play()
	if damage_timer.is_stopped():
		damage_timer.start()  

func stop_firing() -> void:
	flames.emitting = false
	damage_area.set_collision_mask_value(3, false)
	damage_area.set_collision_mask_value(4, false)
	audio_player.stop()
	damage_timer.stop()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		targets.append(body)

func _on_body_exited(body: Node2D) -> void:
	targets.erase(body)

func apply_damage() -> void:
	for target in targets:
		if is_instance_valid(target):
			if target.has_method("add_fire"):
				target.add_fire(1)
			target.take_damage(actual_flame_damage)
