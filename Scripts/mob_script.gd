extends CharacterBody2D

signal shoot
@export var flash_duration: float = 0.2  # Duration of red flash
var normal_color: Color = Color(1, 1, 1)  # Default color (normal)
var flash_color: Color = Color(1, 0, 0)  # Red flash color
var flash_timer: SceneTreeTimer

var sprite: AnimatedSprite2D  # Assuming the enemy has a Sprite2D node
var health: Node
var speed_modifier: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $EnemySprite2
	health = $Health
	flash_timer = get_tree().create_timer(flash_duration)
	flash_timer.timeout.connect(_on_flash_timeout)
	Global.incrementEnemyCount()
	speed_modifier = randf_range(-1,1) * 2
	var follow_node = $EMovementController/Follow
	follow_node.speed += speed_modifier

func take_damage(amount: int):
	# Trigger damage reaction (flashing red)
	flash_red()
	# decrease health
	health.take_damage(amount)

func flash_red():
	sprite.z_index = 100
	sprite.modulate = flash_color
	flash_timer = get_tree().create_timer(flash_duration)
	flash_timer.timeout.connect(_on_flash_timeout)
	
	# Wait for the flash duration and then reset color
	

func _on_flash_timeout():
	print("Is this thing on? mob_script.gd")
	sprite.modulate = normal_color
	sprite.z_index = 1
	flash_timer.timeout.disconnect(_on_flash_timeout)
	
