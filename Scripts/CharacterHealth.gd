extends Node

@export var max_health: float = 100
var current_health: float
signal damage_taken
signal healed

var character: CharacterBody2D
func _ready() -> void:
	current_health = max_health
	var char = get_parent_characterbody2d()
	character = char
	
func _physics_process(delta: float) -> void:
	if current_health <= 0:
		die()
	
func take_damage(amount: float) -> void:
	current_health -= amount
	emit_signal("damage_taken")
	if current_health <= 0:
		current_health = 0
		die()
	else:
		print(character.name, " health:", current_health)
		pass

func heal(amount: float) -> void:
	current_health += amount
	emit_signal("healed")
	if current_health > max_health:
		current_health = max_health
	print(character.name, " health:", current_health)

func die() -> void:
	print(character.name, " died!")
	character.queue_free()
	pass
	
func get_parent_characterbody2d() -> CharacterBody2D:
	var current = get_parent()
	while current:
		if current is CharacterBody2D:
			return current
		current = current.get_parent()
	return null
