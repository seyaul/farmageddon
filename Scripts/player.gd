extends CharacterBody2D

signal shoot
signal melee
signal shockwave
signal disable_shooting
signal enable_shooting

var ammo: int = 10
var max_ammo: int = 10
var ammo_bar: Label
var animation: AnimatedSprite2D

func _ready() -> void:
	# TODO: Find better way to reference nodes within the same scene as the player?
	var crosshairs = get_node("../Crosshairs")
	$Targeter.target = crosshairs
	ammo_bar = get_node("../UserInterfaceLayer/PlayerUI/Ammo")
	var gun = $gun
	gun.bullet_fired.connect(_on_bullet_fired)
	animation = get_node("AnimatedSprite2D")

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
		ammo_bar.text = "No ammo left, press R to reload"
		return
	ammo_bar.text = "Ammo " + str(new_ammo)
