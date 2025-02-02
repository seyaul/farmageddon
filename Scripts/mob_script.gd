extends CharacterBody2D

signal shoot
@export var flash_duration: float = 0.2  # Duration of red flash
var normal_color: Color = Color(1, 1, 1)  # Default color (normal)
var flash_color: Color = Color(1, 0, 0)  # Red flash color
var flash_timer: SceneTreeTimer

var sprite: AnimatedSprite2D  # Assuming the enemy has a Sprite2D node
var health: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $EnemySprite2
	health = $Health
	flash_timer = get_tree().create_timer(flash_duration)
	flash_timer.timeout.connect(_on_flash_timeout)
	Global.incrementEnemyCount()

func take_damage(amount: int):
	# Trigger damage reaction (flashing red)
	flash_red()
	# decrease health
	health.take_damage(amount)

func flash_red():
	sprite.modulate = flash_color
	flash_timer = get_tree().create_timer(flash_duration)
	flash_timer.timeout.connect(_on_flash_timeout)
	# Wait for the flash duration and then reset color
	

func _on_flash_timeout():
	sprite.modulate = normal_color
	flash_timer.timeout.disconnect(_on_flash_timeout)
