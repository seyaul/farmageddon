extends StaticBody2D

@export var blood_dir_path: String
@onready var body: Sprite2D = $Body
@onready var blood: Sprite2D = $Blood
@onready var splatter_animation: AnimatedSprite2D = $Splatter_Animation

func _ready():
	splatter_animation.play("default")  # Play the animation once
	splatter_animation.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	splatter_animation.visible = false # Stops at the last frame

func init(corpse_body_path: String, corpse_scale: float):
	body = $Body
	blood = $Blood
	print(body)
	body.texture = load(corpse_body_path)
	body.scale = Vector2(corpse_scale, corpse_scale)
	