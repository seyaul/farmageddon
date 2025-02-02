extends MarginContainer

signal change_health
@export var health: float
@export var animation_speed: float = 1.0
@export var vibration_range: int
@export var vibration_speed: int
@export var initial_rotation: float = 63.4
@export var final_rotation: float = -63.4
@export var rotation_smooth_speed: float = 5.0

var sprite: Sprite2D
var max_frames:float
var curr_health: float
var playing: bool

var time: int
func _ready() -> void:
	sprite = get_node("Needle")
	curr_health = Global.playerHealth
	print(curr_health, " checking curr health in healthbar..gd")
	sprite.rotation_degrees = initial_rotation
	#change_health.connect(set_curr_health)
	Global.playerHealthNode.damage_taken.connect(handleSignal)
	Global.playerHealthNode.healed.connect(handleSignal)
	#ssetHealthBar()

func _physics_process(delta: float) -> void:
	update_rotation(delta)
	time += 1
	vibrate()
	

func vibrate() -> void:
	if time % vibration_speed == 0:
		sprite.rotation_degrees += vibration_range
		vibration_range = -vibration_range

func handleSignal() -> void: 
	#print("handleSignal actual_health_bar")
	setHealthBar()

func setHealthBar():
	curr_health = Global.playerHealthNode.current_health
	print(curr_health, "checking current health bar amt, health_bar.gd")

func update_rotation(delta: float) -> void:
	var health_fraction = curr_health / health
	var target_rotation = lerp(final_rotation, initial_rotation, health_fraction)
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, target_rotation, rotation_smooth_speed * delta)


## TODO: Feel free to comment this out. This is just for debugging purposes
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == 1 and event.pressed:
			#emit_signal("change_health", -20)
		#if event.button_index == 2 and event.pressed:
			#emit_signal("change_health", 20)
