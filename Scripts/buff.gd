extends TextureRect

@export var Name : String
@export var Stat_type: String
var modifier_name : String
#var player_stats: PlayerStats
#var gun_stats: AllGunStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modifier_name = Name + "_modifier"
	if Stat_type == "player":
		#print(Global.player_stats.get(modifier_name), " debugging buff.gd")
		tooltip_text = Name + ": Current Bonus = " + Global.player_stats.get_data(modifier_name)
	elif Stat_type == "gun":
		tooltip_text = Name + ": Current Bonus = " + String.num(Global.all_gun_stats.get(modifier_name), 4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
