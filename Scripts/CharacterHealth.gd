extends Node

@export var max_health: float = 100
@export var player_max_health: int = 10
var current_health: float
var isDead : bool
signal damage_taken
signal character_died
signal mob_died
signal healed
signal you_win

var character: CharacterBody2D
func _ready() -> void:
	character = get_parent()
	if character.name != "Player":  
		current_health = max_health
	else: 
		#print("player_max_health ", player_max_health)
		#print("global player health ", Global.playerHealth)
		pass
	
	
func _physics_process(delta: float) -> void:
	pass
	
func take_damage(amount: float) -> void:
	if isDead:
		return
	if character.name != "Player":
		current_health -= amount
		if current_health <= 0:
			current_health = 0
			if has_node("../die"):
				$"../die".play()
			die()
	if character.name == "Player":
		Global.playerHealth -= amount
		if Global.playerHealth <= 0:
			Global.playerHealth = 0
			if has_node("../die"):
				$"../die".play()
			#print("dying, global health ", Global.playerHealth)
			die()
	else:
		if has_node("../hurt"):
			$"../hurt".play()
	damage_taken.emit()

func heal(amount: float) -> void:
	Global.playerHealth += amount
	if Global.playerHealth > player_max_health + Global.player_stats.additional_max_health_modifier:
		Global.playerHealth = player_max_health + Global.player_stats.additional_max_health_modifier
	healed.emit()

func die() -> void:
	if isDead:
		return
	if character.name == "Player":
		isDead = true
		character_died.emit()
		await get_tree().create_timer(3).timeout
		if(get_tree() != null):
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
	else:
		mob_died.emit()
		isDead = true
		Global.decrementEnemyCount()
		Global.num_enemies_defeated += 1
		if has_node("../die"):
			await $"../die".finished
		elif has_node("../DeathAnimation"):
			#print("Hello???")
			character.queue_free()
			you_win.emit()
		character.queue_free()
		
func check_sound_playing():
	if $"../hurt".playing:
		$"../hurt".stop()
	elif $"../attacking".playing:
		$"../attacking".stop()
	elif $"../die".playing:
		$"../die".stop()
	elif has_node("../braying"):
		if $"../braying".playing:
			$"../braying".stop()
