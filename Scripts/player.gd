extends CharacterBody2D

signal shoot
signal melee
signal shockwave
signal disable_shooting
signal enable_shooting
signal god_mode_debug

@export var gun_scene: PackedScene

var ammo: int = 10
var max_ammo: int = 10
var ammo_bar: Label
var animation: AnimatedSprite2D
var speed_modifier: float
var hitbox: Area2D
var hitbox_shape: CollisionShape2D
var gun: baseGun

# Tractor dimensions TODO: possibly set these by grabbing the collision shapes from the scene
const TRACTOR_WIDTH: float = 220
const TRACTOR_HEIGHT: float = 160
const HITBOX_EXTENSION: float = 2  # How far the hitbox extends forward

func _ready() -> void:
	# TODO: Find better way to reference nodes within the same scene as the player?
	var crosshairs = get_node("../Crosshairs")
	$Targeter.target = crosshairs
	ammo_bar = get_node("../UserInterfaceLayer/PlayerUI/Ammo")
	if gun_scene:
		equip_new_gun(gun_scene.instantiate())
	else:
		print("Error, no gun equiped in player scene")
	gun.bullet_fired.connect(_on_bullet_fired)
	animation = get_node("AnimatedSprite2D")
	hitbox = get_node("Hitbox")
	hitbox_shape = get_node("Hitbox/CollisionShape2D")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		emit_signal("shoot", "tap", delta)
	elif Input.is_action_pressed("shoot"):
		emit_signal("shoot", "hold", delta)
	elif Input.is_action_just_released("shoot"):
		emit_signal("shoot", "end", delta)
	if Input.is_action_just_pressed("melee"):
		emit_signal("melee")
	if Input.is_action_just_pressed("shockwave"):
		emit_signal("shockwave")

	if Input.is_action_just_pressed("reload"):
		reload()


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
	$Turret.add_child(gun)
	gun.position = Vector2(0, -115)
