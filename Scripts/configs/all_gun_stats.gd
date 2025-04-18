@tool
extends Resource
class_name AllGunStats

# this will be multiplied by the base fire rate of every gun
@export var fire_rate_modifier: float = 1
# this will be multiplied by the base cooldown speed of every gun, ex: if 2 will make 
# cooldown circle retreat in half the time
@export var cooldown_speed_modifier: float = 1

# this is the number of additional bullets the Akorn47 will shoot per fire above 1
@export var akorn47_additional_bullets_per_fire: int = 0

# this modifies the amount of damage per flame tick when mobs are on fire
@export var flame_damage_modifier: float = 1


func reset_to_defaults():
	fire_rate_modifier = 1
	cooldown_speed_modifier = 1
	akorn47_additional_bullets_per_fire = 0
	flame_damage_modifier = 1

func print_all_stats():
	print("=========================Gun Stats:=========================")
	print("fire_rate_modifier: ", fire_rate_modifier)
	print("cooldown_speed_modifier: ", cooldown_speed_modifier)
	print("akorn47_additional_bullets_per_fire", akorn47_additional_bullets_per_fire)
	print("flame_damage_modifier", flame_damage_modifier)
	print("=========================End Gun Stats=========================")
