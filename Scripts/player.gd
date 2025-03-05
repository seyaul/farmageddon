extends CharacterBody2D

signal shoot
signal melee
signal shockwave
signal disable_shooting
signal enable_shooting
signal god_mode_debug
signal update_heat
signal start_cd_timer
signal weapon_switched
signal continuous_started
signal continuous_ended

@export var active_weapons: Array = ["AKorn47", "flamethrower", "rpg"]  # Array showing which weapons to equip
@export var flash_duration: float = 0.2  # Duration of red flash upon taking damage
var weapons_directory = "res://Scenes/weapons/"
var gun_scene_array: Array = []  # Array to hold instances of the guns
var current_gun_index: int = 0  # Index of the current active gun in gun_array

var normal_color: Color = Color(1, 1, 1)  # Default color (normal)
var flash_color: Color = Color(1, 0, 0)  # Red flash color
var ammo: int = 10
var max_ammo: int = 10
var ammo_bar: Label
var animation: AnimatedSprite2D
var hitbox: Area2D
var hitbox_shape: CollisionShape2D
var gun: baseGun
var is_holding
@onready var walk_state = $MoveController/Walk
@onready var turret: Node2D = $Turret
@onready var turretGunSprite: Node2D = $Turret/Gun
@onready var deathAnimation: AnimatedSprite2D = $DeathAnimation
@onready var tankSprite: Sprite2D = $TankSprite
@onready var health: Node = $Health
@onready var damagedAudio: AudioStreamPlayer = $DamagedAudio

func _ready() -> void:
	var crosshairs = get_node("../Crosshairs")
	$Targeter.target = crosshairs
	ammo_bar = get_node("../UserInterfaceLayer/PlayerUI/Ammo")
	setup_weapons()
	if len(gun_scene_array) > 0:
		equip_new_gun(gun_scene_array[current_gun_index].instantiate())
	else:
		print("Error, no gun equiped in player scene")
	# This is commented out to be removed later when we no longer use magazine ammo
	# gun.bullet_fired.connect(_on_bullet_fired)
	if has_node("AnimatedSprite2D"):
		animation = get_node("AnimatedSprite2D")
	hitbox = get_node("Hitbox")
	hitbox_shape = get_node("Hitbox/CollisionShape2D")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		emit_signal("shoot", "tap", delta)
		emit_signal("update_heat")
	elif Input.is_action_pressed("shoot"):
		if !is_holding:
			emit_signal("continuous_started")
		emit_signal("shoot", "hold", delta)
		is_holding = true
	elif Input.is_action_just_released("shoot"):
		if is_holding:
			emit_signal("continuous_ended")
		emit_signal("shoot", "end", delta)
		emit_signal("start_cd_timer")
		is_holding = false
	if Input.is_action_just_pressed("melee"):
		emit_signal("melee")
	if Input.is_action_just_pressed("shockwave"):
		emit_signal("shockwave")

	if Input.is_action_just_pressed("switch_weapon"):
		iterate_weapon()

func reload():
	emit_signal("disable_shooting")
	ammo_bar.label_settings.font_color = Color.RED
	ammo_bar.text = "Reloading"
	await get_tree().create_timer(2).timeout
	ammo = max_ammo
	update_ammo_bar(ammo)
	emit_signal("enable_shooting")
	

func _on_bullet_fired() -> void:
	ammo -= 1
	update_ammo_bar(ammo)
	if ammo == 0:
		emit_signal("disable_shooting")

# _on_health_character_died() handles a character died signal from the
# CharacterHealth child node in order to play the death animation
func _on_health_character_died():
	walk_state.modify_speed(0)
	tankSprite.visible = false
	turret.visible = false
	deathAnimation.visible = true
	deathAnimation.play()

func update_ammo_bar(new_ammo: int):
	if new_ammo == 0:
		ammo_bar.label_settings.font_color = Color.RED
		ammo_bar.text = "No ammo left, press R to reload"
		return
	ammo_bar.text = "Ammo " + str(new_ammo)
	ammo_bar.label_settings.font_color = Color.WHITE

func equip_new_gun(new_gun: baseGun):
	if gun:
		gun.queue_free()  
	gun = new_gun
	turret.switch_gun_sprite(new_gun.name)
	turret.add_child(gun)
	gun.position = Vector2(0, -115) # y = -115
	
	await get_tree().process_frame
	emit_signal("weapon_switched")

func setup_weapons():
	for weapon_name in active_weapons:
		var weapon_scene = load(weapons_directory + weapon_name + ".tscn")
		gun_scene_array.append(weapon_scene)

func iterate_weapon():
	if current_gun_index == len(gun_scene_array) - 1:
		current_gun_index = 0
	else:
		current_gun_index += 1
	var new_gun = gun_scene_array[current_gun_index].instantiate()
	equip_new_gun(new_gun)

func modify_speed(speed_modifier: float):
	walk_state.modify_speed(speed_modifier)

func reset_speed():
	walk_state.reset_speed_modifier()
	
func take_damage(amount: int):
	# Trigger damage reaction (flashing red)
	damagedAudio.play()
	flash_red()
	# decrease health
	health.take_damage(amount)

func flash_red():
	tankSprite.modulate = flash_color
	var flash_timer = get_tree().create_timer(flash_duration)
	flash_timer.timeout.connect(_on_flash_timeout)
	# Wait for the flash duration and then reset color

func _on_flash_timeout():
	tankSprite.modulate = normal_color
