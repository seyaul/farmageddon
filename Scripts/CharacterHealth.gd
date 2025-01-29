extends Node

@export var max_health: float = 100
var current_health: float
signal damage_taken
signal character_died
signal healed

var character: CharacterBody2D
func _ready() -> void:
	current_health = max_health
	character = get_parent()
	
func _physics_process(delta: float) -> void:
	if current_health <= 0:
		die()
	
func take_damage(amount: float) -> void:
	current_health -= amount
	damage_taken.emit()
	if current_health <= 0:
		current_health = 0
		die()
	else:
		print(character.name, " health:", current_health)

func heal(amount: float) -> void:
	healed.emit()
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	print(character.name, " health:", current_health)

func die() -> void:
	print(character.name, " died!")
	character_died.emit() #may not need this, just being safe
	emit_signal("character_died", self)
	character.queue_free()
