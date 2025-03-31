extends Node2D

@export var weapon_sprites_path = "res://Sprites/player_sprites/guns/"
@onready var gun_sprite = $Gun

func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()

	# Convert mouse position into the tank's local space
	var tank = get_parent()  # Assuming the tank is the parent node
	var local_mouse_position = tank.to_local(mouse_position)

	# Get direction to the mouse and rotate turret
	var direction_to_mouse = local_mouse_position.normalized()
	rotation = direction_to_mouse.angle() + deg_to_rad(90)

func switch_gun_sprite(name: String):
	print("loading texture: ", weapon_sprites_path + name + ".png")
	gun_sprite.texture = load(weapon_sprites_path + name + ".png")
	if name == "AKorn47":
		gun_sprite.position = Vector2(0, 0)
		gun_sprite.scale = Vector2(.4, .4)
	elif name == "flamethrower":
		gun_sprite.position = Vector2(0, 0)
		gun_sprite.scale = Vector2(.7, .7)
	elif name == "rpg":
		gun_sprite.position = Vector2(16, -68)
		gun_sprite.scale = Vector2(1, 1)
