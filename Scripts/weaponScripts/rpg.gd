extends baseGun

func _ready() -> void:
	super._ready()

	# Customize weapon-specific properties
	base_fire_rate = 1
	bullets_per_fire = 1
	spread = 0
	projectile_speed = 30000
	automatic = false
