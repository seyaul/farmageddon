@tool
extends Resource
class_name PlayerStats

# These are the modifiers, modify them within a run to modify the player's 
# intrarun stats

# additional_max_health is additional health that the player has above base max health
@export var additional_max_health: int = 2
# additional_speed is additional speed that the player has above base speed
@export var additional_speed: int = 0
# speed_modifier is multiplied by the players base_speed+additional_speed
@export var speed_modifier: float = 1