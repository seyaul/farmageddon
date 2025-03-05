extends TextureProgressBar
@export var max_heat: float = 100.0  # Max heat before overheating
var heat_increase_rate: float  # Heat gained per shot
@export var heat_cool_rate: float = 20.0  # Heat lost per second
@export var overheat_penalty_time: float = 5  # Time you cannot shoot when overheated
@export var min_shot_interval: float = 0.1

var heat: float = 0.0  # Current heat level
var is_overheated: bool = false
var is_shooting: bool = false

var cooling_start : bool
var gun_node : Node2D
var penalty_applied : bool

@onready var time_till_start_cooldown_timer = $CooldownTimer
@onready var penalty_timer = $PenaltyTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Global.playerInstance.print_tree()
	#gun_node = Global.playerInstance.get_node("Turret/Gun")
	#print(gun_node)
	penalty_timer.timeout.connect(handle_penalty_timer_complete)
	Global.playerInstance.start_cd_timer.connect(handle_cooling)
	Global.playerInstance.weapon_switched.connect(check_and_connect_gun)
	time_till_start_cooldown_timer.timeout.connect(_on_cooling_delay_end)
	if Global.playerInstance.gun:
		gun_node = Global.playerInstance.gun
	else: 
		print("no gun rn in ready for heating_gauge")
	await get_tree().process_frame
	check_and_connect_gun()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_shooting and cooling_start:
		heat -= heat_cool_rate * delta
		heat = max(heat, 0)
		update_heat_gauge()
	
	#if Global.playerInstance.gun:
		#gun_node = Global.playerInstance.gun
	
func handle_signal(heating_rate):
	#print("This should be printing, heatinggauge")
	if is_overheated:
		return
	#print("shooting in heatinggauge.gd")
	is_shooting = true
	cooling_start = false
	heat_increase_rate = heating_rate
	heat += heat_increase_rate
	heat = min(heat, max_heat)
	update_heat_gauge()
	
	if !time_till_start_cooldown_timer.is_stopped():
		time_till_start_cooldown_timer.stop()
		#print("Timer disconnected heatingGauge")
	if heat == max_heat:
		#print("Overheated")
		is_overheated = true
		penalty_timer.start()  # Overheat cooldown
		gun_node.disable_shooting_handler()
	#if is_overheated:
		#gun_node.disable_shooting_handler()
		#return  # Prevent shooting if overheated


func _on_cooling_delay_end():
	is_shooting = false
	cooling_start = true
	

func update_heat_gauge():
	self.value = (heat / max_heat) * 100
	
func handle_cooling():
	#if is_shooting:
		#return
	#print("Timer started, hg.gd")
	time_till_start_cooldown_timer.stop()
	time_till_start_cooldown_timer.start()
	
func check_and_connect_gun():
	#print("is this thing on ", gun_node)
	if gun_node:
		if is_instance_valid(gun_node):
			if gun_node.bullet_fired.is_connected(handle_signal):
				if !penalty_timer.is_stopped():
					penalty_applied = true
					print("When swithing, this should print. ", penalty_applied)
				elif penalty_timer.is_stopped():
					print("This shouldn't be printing")
					penalty_applied = false
				gun_node.bullet_fired.disconnect(handle_signal)
				#print("signal disconnected")
	if Global.playerInstance.gun:
		gun_node = Global.playerInstance.gun
		if gun_node.fire_type == "Discrete":
			#print(gun_node, " gun type? ", penalty_applied)
			if !penalty_timer.is_stopped():
				gun_node.bullet_fired.connect(handle_signal)
				gun_node.disable_shooting_handler()
				var time_left = penalty_timer.time_left
				penalty_timer.start(time_left)
				#print("discretepenalty started")
			else:
				gun_node.bullet_fired.connect(handle_signal)
		else:
			if !penalty_timer.is_stopped():
				gun_node.continuous_started.connect(handle_signal)
				gun_node.disable_shooting_handler()
				var time_left = penalty_timer.time_left
				penalty_timer.start(time_left)
				#print("contpenalty started")
			else:
				gun_node.continuous_started.connect(handle_signal)
			#print("successfully connected? heating_gauge.gd")
	else:
		print("not loaded yet, waiting")
		await get_tree().process_frame
		check_and_connect_gun()

func handle_penalty_timer_complete():
	gun_node.enable_shooting_handler()
	is_overheated = false
	penalty_timer.stop()
	#print("penalty timer no longer stopped")
	
