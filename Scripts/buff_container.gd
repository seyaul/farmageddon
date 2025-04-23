extends HBoxContainer

@onready var buff_placeholder_scn = preload("res://Scenes/buff_placeholder.tscn")
@onready var health_boost_scn = preload("res://Scenes/max_health_buff.tscn")
@onready var lifesteal_scn = preload("res://Scenes/lifesteal_buff.tscn")
@onready var crosshair_heating_scn = preload("res://Scenes/crosshair_heating_buff.tscn")
@onready var fire_rate_scn = preload("res://Scenes/fire_rate_buff.tscn")
@onready var speed_scn = preload("res://Scenes/speed_buff.tscn")
@onready var dual_fire_scn = preload("res://Scenes/dual_fire_scn.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_buffs()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func spawn_buffs():
	print("hello chuzzuy")
	var buff_list = Global.get_chosen_buffs()
	print(buff_list, " buff list")
	for buff in buff_list:
		if buff == "Max Health Boost":
			var hud_buff = health_boost_scn.instantiate()
			add_child(hud_buff)
			print("added!")
		elif buff == "Speed Boost":
			var hud_buff = speed_scn.instantiate()
			add_child(hud_buff)
			print("added!")
		elif buff == "Heating Rate Reduction":
			var hud_buff = crosshair_heating_scn.instantiate()
			add_child(hud_buff)
			print("added!")
		elif buff == "Fire Rate Buff":
			var hud_buff = fire_rate_scn.instantiate()
			add_child(hud_buff)
			print("added!")
		elif buff == "Lifesteal Ability":
			var hud_buff = lifesteal_scn.instantiate()
			add_child(hud_buff)
			print("added!")
		elif buff == "Multi-Shot Upgrade":
			var hud_buff = dual_fire_scn.instantiate()
			add_child(hud_buff)
		else:
			print("Error error nothing of that name CHUZ")
