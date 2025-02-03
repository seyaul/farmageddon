extends baseBullet

@export var explosion_radius: float = 50
@export var explosion_damage: int = 20
@export var explosion_effect_scene: PackedScene  # Optional, for visual explosion effect

func _handle_collisions(collision: KinematicCollision2D) -> void:
	# Spawn explosion effect
	if explosion_effect_scene:
		var explosion_effect = explosion_effect_scene.instantiate()
		get_parent().add_child(explosion_effect)
		explosion_effect.global_position = global_position 

	# Deal damage to enemies in the explosion radius
	_explode()

	# Remove the bullet after explosion
	queue_free()
	 
	
func _explode() -> void:
	# Get all objects in the explosion radius
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = CircleShape2D.new()
	query.shape.radius = explosion_radius
	query.transform = Transform2D(0, global_position)
	# query.collision_layer = collision_layer  # Ensure it matches the bullet's layer

	var collisions = space_state.intersect_shape(query)
	for collision in collisions:
		print("collision")
		
		var collider = collision.collider
		var enemy_health = collider.get_node("Health")
	
		if enemy_health and enemy_health.has_method("take_damage"):
			print("damaging enemy")
			enemy_health.take_damage(10)  
