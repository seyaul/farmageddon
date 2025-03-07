extends baseBullet

@export var explosion_radius: float = 50
@export var explosion_damage: int = 20
@export var blast_scene: PackedScene  # Optional, for visual explosion effect

func _handle_collisions(collision: KinematicCollision2D) -> void:
	# Deal damage to enemies in the explosion radius
	_explode()

	# Remove the bullet after explosion
	queue_free()

# Override parent kill_bullet function to explode when no hit
func kill_bullet():
	_explode()
	queue_free()

func _explode() -> void:
	# Spawn explosion effect
	if blast_scene:
		var blast = blast_scene.instantiate()
		blast.global_position = global_position 
		get_tree().current_scene.add_child(blast)
	

	
