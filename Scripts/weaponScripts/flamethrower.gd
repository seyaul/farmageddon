extends baseGun

var flames: CPUParticles2D

func _ready() -> void:
    super._ready()

    flames = $CPUParticles2D
    flames.emitting = false
    # Customize weapon-specific properties
    fire_rate = 1
    bullets_per_fire = 1
    spread = 0
    projectile_speed = 30000
    automatic = false

func fire(delta: float) -> void:
    if !active_shooting:
        flames.emitting = false
        return

    print("firing")
    
    # Get the mouse position in global coordinates
    var mouse_position = get_global_mouse_position()
    var direction_to_mouse = (mouse_position - global_position).normalized()
    
    # Rotate the particles in the direction of aim
    flames.rotation = direction_to_mouse.angle()
    
    flames.emitting = true


