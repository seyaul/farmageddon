extends CharacterBody2D

signal shoot
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $EnemySprite2
	health = $Health
	healthBar = $EnemySprite2/ProgressBar
	healthBar.visible = false
	#flash_timer = get_tree().create_timer(flash_duration)
	#flash_timer.timeout.connect(_on_flash_timeout)
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
	flash_timer.timeout.disconnect(_on_flash_timeout)
	
func _on_hb_timeout():
	healthBar.visible = false

	
	

	
