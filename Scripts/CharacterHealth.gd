extends Node

@export var max_health: float = 100
var current_health: float
signal damage_taken
signal character_died
signal healed

var character: CharacterBody2D
func _ready() -> void:
	character = get_parent()
	if character.name != "Player": #if it is a mob 
		current_health = max_health
	else: # if it is the player and it isn't new game
		current_health = Global.playerHealth
	
	
func _physics_process(delta: float) -> void:
	pass
	
func take_damage(amount: float) -> void:
	current_health -= amount
	damage_taken.emit()
	if current_health <= 0:
		current_health = 0
		die()
	else:
		#print(character.name, " health:", current_health)
		pass

func heal(amount: float) -> void:
	healed.emit()
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	#print(character.name, " health:", current_health)

func die() -> void:
	if has_node("../Player"):
		pass
	else: 
		Global.decrementEnemyCount()
		character.queue_free()
