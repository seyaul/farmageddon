extends Area2D

func _on_Hitbox_body_entered(body):
	var enemy = body
	if enemy.is_in_group("mobs"):
		enemy.take_damage(10)  
		var knockback_dir = (enemy.global_position - global_position).normalized()
		enemy.apply_knockback(knockback_dir * 700)
	
