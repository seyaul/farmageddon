@tool
extends Resource
class_name AllGunStats

# this will be multiplied by the base fire rate of every gun
@export var fire_rate_modifier: float = 1
# this will be multiplied by the base cooldown speed of every gun, ex: if 2 will make 
# cooldown circle retreat in half the time
@export var cooldown_speed_modifier: float = 1


func reset_to_defaults():
    fire_rate_modifier = 1
    cooldown_speed_modifier = 1