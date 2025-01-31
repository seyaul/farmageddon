extends MarginContainer

signal change_health
@export var health: float
@export var animation_speed: float = 1.0
@export var vibration_range: int
@export var vibration_speed: int
@export var initial_rotation: float = -60.0
@export var final_rotation: float = 63.4
@export var rotation_smooth_speed: float = 5.0

var sprite: Sprite2D
var max_frames:float
var curr_health: float
var playing: bool

var time: int
func _ready() -> void:
	sprite = get_node("Needle")
	curr_health = health
	sprite.rotation_degrees = initial_rotation
	change_health.connect(set_curr_health)
	$"../../../Player/Health".damage_taken.connect(handleSignal)
	$"../../../Player/Health".healed.connect(handleSignal)
	setHealthBar()

func _physics_process(delta: float) -> void:
	update_rotation(delta)
	
	
	time += 1
	vibrate()
	


func vibrate() -> void:
	if time % vibration_speed == 0:
		sprite.rotation_degrees += vibration_range
		vibration_range = -vibration_range

func handleSignal() -> void: 
	setHealthBar()

func setHealthBar():
	curr_health = $"../../../Player/Health".current_health

func update_rotation(delta: float) -> void:
	var health_fraction = curr_health / health
	#print(curr_health, " curr health")
	#print(health_fraction, " health fraction")
	var target_rotation = lerp(initial_rotation, final_rotation, health_fraction)
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, target_rotation, rotation_smooth_speed * delta)

func set_curr_health(change_in_health: float) -> void:
	curr_health = clamp(curr_health + change_in_health, 0, health)

## TODO: Feel free to comment this out. This is just for debugging purposes
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == 1 and event.pressed:
			#emit_signal("change_health", -20)
		#if event.button_index == 2 and event.pressed:
			#emit_signal("change_health", 20)
