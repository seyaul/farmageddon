extends baseGun

func _ready() -> void:
     # Call the parent's _ready() to ensure initialization
    super._ready()

    # Customize weapon-specific properties
    fire_rate = 10
    bullets_per_fire = 1
    spread = 0
    projectile_speed = 30000
    automatic = false
