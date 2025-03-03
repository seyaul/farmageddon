extends TextureProgressBar
@export var max_heat: float = 100.0  # Max heat before overheating
var heat_increase_rate: float  # Heat gained per shot
@export var heat_cool_rate: float = 20.0  # Heat lost per second
@export var overheat_penalty_time: float = 5  # Time you cannot shoot when overheated
@export var min_shot_interval: float = 0.1

var heat: float = 0.0  # Current heat level
var is_overheated: bool = false
var is_shooting: bool = false

var gun_node : Node2D

@onready var cooldown_timer = $CooldownTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Global.playerInstance.print_tree()
	#gun_node = Global.playerInstance.get_node("Turret/Gun")
	#print(gun_node)
	Global.playerInstance.start_cd_timer.connect(handle_cooling)
	Global.playerInstance.weapon_switched.connect(check_and_connect_gun)
	cooldown_timer.timeout.connect(_on_cooling_delay_end)
	if Global.playerInstance.gun:
		gun_node = Global.playerInstance.gun
	else: 
		print("no gun rn in ready for heating_gauge")
	await get_tree().process_frame
	check_and_connect_gun()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_shooting:
		heat -= heat_cool_rate * delta
		heat = max(heat, 0)
		update_heat_gauge()
	if Global.playerInstance.gun:
		gun_node = Global.playerInstance.gun
	
func handle_signal(heating_rate):
	#print("shooting in heatinggauge.gd")
	is_shooting = true
	heat_increase_rate = heating_rate
	heat += heat_increase_rate
	heat = min(heat, max_heat)
	if is_overheated:
		gun_node.disable_shooting_handler()
		return  # Prevent shooting if overheated
	cooldown_timer.stop()
	
	if heat >= max_heat:
		is_overheated = true
		await get_tree().create_timer(overheat_penalty_time).timeout  # Overheat cooldown
		is_overheated = false  # Allow shooting again
		gun_node.enable_shooting_handler()

	update_heat_gauge()

func _on_cooling_delay_end():
	is_shooting = false

func update_heat_gauge():
	self.value = (heat / max_heat) * 100
	
func handle_cooling():
		
	print("Timer started, hg.gd")
	cooldown_timer.start()
	
func check_and_connect_gun():
	if gun_node:
		if is_instance_valid(gun_node):
			if gun_node.bullet_fired.is_connected(handle_signal):
				gun_node.bullet_fired.disconnect(handle_signal)
		
	if Global.playerInstance.gun:
		gun_node = Global.playerInstance.gun
		if gun_node.fire_type == "Discrete":
			gun_node.bullet_fired.connect(handle_signal, heat_increase_rate)
		else:
			gun_node.continuous_started.connect(handle_signal, heat_increase_rate)
			print("successfully connected? heating_gauge.gd")
	else:
		print("not loaded yet, waiting")
		await get_tree().process_frame
		check_and_connect_gun()
