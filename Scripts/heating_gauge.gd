extends TextureProgressBar
@export var max_heat: float = 100.0  # Max heat before overheating
@export var heat_increase_rate: float = 1.0  # Heat gained per shot
@export var heat_cool_rate: float = 40.0  # Heat lost per second
@export var overheat_penalty_time: float = 1.0  # Time you cannot shoot when overheated

var heat: float = 0.0  # Current heat level
var is_overheated: bool = false

var gun_node : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.playerInstance.update_heat.connect(handle_signal)
	if Global.playerInstance.gun:
		gun_node = Global.playerInstance.gun
	else: 
		print("no gun rn in ready for heating_gauge")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if heat > 0:
		heat -= heat_cool_rate * delta
		heat = max(heat, 0)  # Ensure it doesn't go below zero
		update_heat_gauge()
	if Global.playerInstance.gun:
		gun_node = Global.playerInstance.gun
	
func handle_signal():
	#print("shooting in heatinggauge.gd")
	if is_overheated:
		gun_node.disable_shooting_handler()
		return  # Prevent shooting if overheated

	heat += heat_increase_rate
	if heat >= max_heat:
		heat = max_heat
		is_overheated = true
		await get_tree().create_timer(overheat_penalty_time).timeout  # Overheat cooldown
		is_overheated = false  # Allow shooting again
		gun_node.enable_shooting_handler()

	update_heat_gauge()


func update_heat_gauge():
	self.value = (heat / max_heat) * 100
