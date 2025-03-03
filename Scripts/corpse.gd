extends Area2D

var body_path: String
var c_scale: float
var darkened: bool
@export var blood_dir_path: String
@onready var body: Sprite2D = $Body
@onready var blood: Sprite2D = $Blood
@onready var splatter_animation: AnimatedSprite2D = $SplatterAnimation
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	splatter_animation.play("default")  # Play the animation once
	body.texture = load(body_path)
	body.scale = Vector2(c_scale, c_scale)
	collision_shape.scale = Vector2(c_scale, c_scale)
	if darkened:
		body.modulate = body.modulate.darkened(.5)

func _on_animation_finished():
	splatter_animation.visible = false # Stops at the last frame

func init(corpse_body_path: String, corpse_scale: float):
	body_path = corpse_body_path
	c_scale = corpse_scale

func darken():
	darkened = true

func _hide_body():
	body.visible = false

func _on_body_entered(body: Node2D):
	if body.is_in_group("mobs"):
		body.slow_down(0.4, 3)
	elif body.name == "Player":
		#in this case we are modifying the player
		body.slow_down(0.6)
	


func _on_body_exited(body:Node2D) -> void:
	if body.is_in_group("mobs"):
		pass
	elif body.name == "Player":
		#in this case we are modifying the player
		body.reset_speed()
