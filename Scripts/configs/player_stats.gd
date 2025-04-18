@tool
extends Resource
class_name PlayerStats

# These are the modifiers, modify them within a run to modify the player's 
# intrarun stats

# additional_max_health is additional health that the player has above base max health
@export var additional_max_health_modifier: int = 0
# additional_speed is additional speed that the player has above base speed
@export var additional_speed_modifier: int = 0
# speed_modifier is multiplied by the players base_speed+additional_speed
@export var speed_modifier: float = 1
# lifesteal_chance/100 is the chance of getting a half heart back when you kill an enemy    
@export var lifesteal_chance_modifier: float = 0.0

func reset_to_defaults():
	additional_max_health_modifier = 0
	additional_speed_modifier = 0
	speed_modifier = 1
	lifesteal_chance_modifier = 0.0

func print_all_stats():
	print("=========================Player Stats:=========================")
	print("Additional Max Health: ", additional_max_health_modifier)
	print("Additional Speed: ", additional_speed_modifier)
	print("Speed Modifier: ", speed_modifier)
	print("Lifesteal Chance: ", lifesteal_chance_modifier)
	print("=========================End Player Stats=========================")

func get_data(name: String) -> String:
	if name == "lifesteal_chance_modifier":
		print(lifesteal_chance_modifier, str(lifesteal_chance_modifier))
		return str(lifesteal_chance_modifier * 100) + "%"
	return str(get(name))
