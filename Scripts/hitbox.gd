extends Area2D

func _on_Hitbox_body_entered(body):
	var enemy = body
	if enemy.is_in_group("mobs"):
		var knockback_dir = (enemy.global_position - global_position).normalized()
		if enemy.has_method("apply_knockback"):
			enemy.apply_knockback(knockback_dir * 700)
			enemy.take_damage(10)  
	
