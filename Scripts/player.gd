extends CharacterBody2D

signal shoot
signal melee
signal shockwave

var ammo: int = 100
var max_ammo: int = 100
var ammo_bar: Label

func _ready() -> void:
	var crosshairs = get_node("../Crosshairs")
	$Targeter.target = crosshairs
	ammo_bar = get_node("../UserInterfaceLayer/PlayerUI/Ammo")
	var gun = $pistol
	gun.bullet_fired.connect(_on_bullet_fired)

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

func reload():
	ammo = max_ammo
	update_ammo_bar(ammo)

func _on_bullet_fired() -> void:
	ammo -= 1
	print("Ammo remaining:", ammo)
	update_ammo_bar(ammo)

func update_ammo_bar(new_ammo: int):
	ammo_bar.text = "Ammo " + str(new_ammo)
