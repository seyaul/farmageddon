extends CharacterBody2D

signal shoot
signal knocked_back
signal stunned

@export var flash_duration: float = 0.2  # Duration of red flash
var hb_timer_duration: float = 1.5
var normal_color: Color = Color(1, 1, 1)  # Default color (normal)
var flash_color: Color = Color(1, 0, 0)  # Red flash color
var flash_timer: SceneTreeTimer
var hb_timer : SceneTreeTimer
var sprite: AnimatedSprite2D  # Assuming the enemy has a Sprite2D node
var health: Node
var speed_modifier: float
var healthBar: Node
var follow_node: Node

@export var max_fire_level: int = 3
@export var fire_decay_rate: float = 1
@export var damage_per_fire_tick: int = 5
var fire_timer: Timer
var on_fire: bool
var fire_level: int # This level will determine how "on fire" the mob is and will decay over time
var targeter: Node
@onready var fire: AnimatedSprite2D = $Fire
@onready var stunAnimation: AnimatedSprite2D = $StunAnimation
@export var corpse_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $EnemySprite2
	health = $Health
	healthBar = $EnemySprite2/ProgressBar
	healthBar.visible = false
	Global.incrementEnemyCount()
	speed_modifier = randf_range(-1,1) * 2
	follow_node = $EMovementController/Follow
	var lunge_node = $EMovementController/Lunge
	targeter = $Targeter
	if lunge_node && targeter:
		lunge_node.disable_targeter.connect(disable_targeter_handler)
		lunge_node.enable_targeter.connect(enable_targeter_handler)
	if lunge_node:
		lunge_node.play_pre_lunge_animation.connect(_handle_play_pre_lunge)
	if follow_node:
		follow_node.play_walk_animation.connect(_handle_play_walk)
	if sprite:
		sprite.play("walk")
	follow_node.speed += speed_modifier
	health.mob_died.connect(die)
	follow_node.no_longer_slowed.connect(end_slow)
	setup_fire_timer()

func take_damage(amount: int):
	# Trigger damage reaction (flashing red)
	flash_red()
	# decrease health
	health.take_damage(amount)

func setup_fire_timer():
	# Timer to apply damage over time
	fire_timer = Timer.new()
	fire_timer.wait_time = fire_decay_rate
	fire_timer.autostart = true
	fire_timer.one_shot = false
	fire_timer.paused = false
	fire_timer.timeout.connect(fire_ticker)
	add_child(fire_timer)

func add_fire(levels_to_add: int):
	if levels_to_add + fire_level > max_fire_level:
		fire_level = max_fire_level
	else:
		fire_level += levels_to_add

	set_fire_opacity()
	fire.visible = true


func fire_ticker(): 
	if fire_level == 0:
		fire.visible = false
		return
	take_damage(damage_per_fire_tick)
	fire_level -= 1
	set_fire_opacity()

func set_fire_opacity():
	if fire_level == 1:
		fire.modulate.a = .2
	elif fire_level == 2:
		fire.modulate.a = .5
	elif fire_level == 3:
		fire.modulate.a = .8

func apply_knockback(force: Vector2):
	emit_signal("knocked_back", force)

func flash_red():
	healthBar.visible = true
	sprite.modulate = flash_color
	flash_timer = get_tree().create_timer(flash_duration)
	if hb_timer:
		hb_timer.timeout.disconnect(_on_hb_timeout)
	hb_timer = get_tree().create_timer(hb_timer_duration)
	flash_timer.timeout.connect(_on_flash_timeout)
	hb_timer.timeout.connect(_on_hb_timeout)
	# Wait for the flash duration and then reset color
	

func _on_flash_timeout():
	sprite.modulate = normal_color
	sprite.z_index = 1
	
func _on_hb_timeout():
	healthBar.visible = false

func die():
	if corpse_scene:
		var corpse_instance = corpse_scene.instantiate()
		if name == "Shooter":
			corpse_instance.init("res://Sprites/new_chicken_sprites/corpse + blood.png", 0.125)
		elif name == "SmartPather":
			corpse_instance.init("res://Sprites/new_bull_sprites/bull_corpse.png", 0.25)
		corpse_instance.global_position = global_position
		# Need to figure out why this works
		corpse_instance.rotation = global_rotation - deg_to_rad(90)
		if fire_level > 0:
			corpse_instance.darken()
		# :( refactor this bs
		get_parent().get_parent().get_parent().get_parent().add_child(corpse_instance)

func slow_down(speed_modifier: float, seconds: float):
	sprite.speed_scale = speed_modifier
	follow_node.slow_down(speed_modifier, seconds)

func end_slow():
	sprite.speed_scale = 1
	sprite.modulate = normal_color


func disable_targeter_handler():
	targeter.disabled = true

func enable_targeter_handler():
	targeter.disabled = false

func _handle_play_pre_lunge():
	sprite.play("pre_lunge")

func _handle_play_walk():
	sprite.play("walk")	

func stun():
	stunned.emit()

func play_stun_animation():
	disable_targeter_handler()
	sprite.pause()
	if stunAnimation:
		stunAnimation.visible = true

func stop_stun_animation():
	enable_targeter_handler()
	sprite.play()
	if stunAnimation:
		stunAnimation.visible = false
	