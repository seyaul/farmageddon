extends baseGun

func _ready() -> void:
    super._ready()
    
    fire_rate = 10
    bullets_per_fire = 5
    spread = 10
    projectile_speed = 30000
    automatic = false
