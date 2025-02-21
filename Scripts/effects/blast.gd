extends Node2D

@export var damage: int = 50  # Explosion damage
@onready var particles = $Particles
@onready var explosion_area = $BlastRadius
@onready var explosion_sound = $Sound

func _ready():
	particles.emitting = true 
   # explosion_sound.play()
	await get_tree().create_timer(0.5).timeout 
	queue_free() 


func _on_blast_radius_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
			body.take_damage(damage)
