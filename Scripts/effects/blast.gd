extends Node2D

@export var damage: int = 50  # Explosion damage
@export var stuns: bool = true
@onready var particles = $Particles
@onready var explosion_area = $BlastRadius
@onready var explosion_sound = $Sound

func _ready():
	particles.emitting = true 
	explosion_sound.play()
	await get_tree().create_timer(0.7).timeout 
	queue_free() 


func _on_blast_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		body.take_damage(damage)
		if stuns:
			if body.has_method("stun"):
				body.stun()
	# else:
	# 	print(body.name)
	elif body.name == "Player":
		print("take damage")
		body.take_damage(1)
