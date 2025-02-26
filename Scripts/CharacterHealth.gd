extends Node

@export var max_health: float = 100
@export var player_max_health: int = 10
var current_health: float
signal damage_taken
signal character_died
signal mob_died
signal healed

var character: CharacterBody2D
func _ready() -> void:
	character = get_parent()
	if character.name != "Player":  
		current_health = max_health
	else: 
		player_max_health = player_max_health + Global.player_stats.additional_max_health
		current_health = Global.playerHealth
		print("current_health ", current_health)
	
	
func _physics_process(delta: float) -> void:
	pass
	
func take_damage(amount: float) -> void:
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		die()
	else:
		pass
	damage_taken.emit()

func heal(amount: float) -> void:
	healed.emit()
	current_health += amount
	if current_health > max_health:
		current_health = max_health

func die() -> void:
	if character.name == "Player":
		await get_tree().create_timer(0.68).timeout
		if(get_tree() != null):
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
	else:
		mob_died.emit()
		Global.decrementEnemyCount()
		character.queue_free()
