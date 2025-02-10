extends Node2D

func _physics_process(delta: float) -> void:
    var mouse_position = get_global_mouse_position()

    # Convert mouse position into the tank's local space
    var tank = get_parent()  # Assuming the tank is the parent node
    var local_mouse_position = tank.to_local(mouse_position)

    # Get direction to the mouse and rotate turret
    var direction_to_mouse = local_mouse_position.normalized()
    rotation = direction_to_mouse.angle() + deg_to_rad(90)