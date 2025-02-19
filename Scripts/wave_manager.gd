extends Node

@export var enemy_bull_scene = preload("res://Scenes/smart_pather.tscn")
@export var enemy_chicken_scene = preload("res://Scenes/shooter.tscn")
var player_instance
@export var num_enemies : int = 16 # number of enemies to spawn, probably len(list_enemies)
var list_enemies : Array # list of a mapping of enemies to how many of that enemy to spawn
@export var stage_type : String # variable that tracks what kind of stage we are on 
@export var stage_difficulty_cost : float # variable to determin the list of enemies
@export var num_waves : int = 3
#@export var spawn_interval : int = 5 
# ask groupmates if there is a way to set these exported variables from the map scene
#var intervals_passed : int = 0
var waves_completed : int = 0
var all_enemies_spawned : bool = false

var spawn_timer : float

# This is a variable to cap the number of enemies on screen at one instance.
# This would be tracked by checking the global enemy count in a while loop 
# and then prohibiting the spawning of eenemies. the timer starting would also need
# to go into this while loop. This would have to be dynamically adjusted based 
# on the level's difficulty. 
var max_enemies_on_screen : int = 15

signal wave_changed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_instance = Global.playerInstance
	spawn_on_timer(enemy_bull_scene)
	


func target_manager(targeterNode: Node, followNode: Node) -> void:
	var rand_target_det = randi_range(0,4)
	var waypoint1 = player_instance.get_node("wayPoint1")
	var waypoint2 = player_instance.get_node("wayPoint2")
	var waypoint3 = player_instance.get_node("wayPoint3")
	var waypoint4 = player_instance.get_node("wayPoint4")
	var target
	match rand_target_det:
		0: 
			targeterNode.target = player_instance
			followNode.follow_target = player_instance 
		1: 
			targeterNode.target = waypoint1
			followNode.follow_target = waypoint1
		2: 
			targeterNode.target = waypoint2
			followNode.follow_target = waypoint2
		3:
			targeterNode.target = waypoint3
			followNode.follow_target = waypoint3
		4:
			targeterNode.target = waypoint4
			followNode.follow_target = waypoint4
	pass


# Currently this function only works for the smartpather due to some niche
# situation with getting the targeter/follower node
func spawn_on_timer(enemy_scene_type):
	#intervals_passed += 1
	#for i in int(num_enemies / spawn_interval) :
	for i in range(0, num_enemies):
		spawn_timer = randf_range(0, 5)
		var enemy_instance = enemy_scene_type.instantiate()
		#var chicken_instance = enemy_chicken_scene.instantiate()
		#var bull_instance = enemy_bull_scene.instantiate() 
		#enemy_instance.print_tree() (GOATED FUNCTION)
		if enemy_instance is Node2D:
			var rand_wall_choose = randi_range(0,1)
			var rand_orientation = [-1,1]
			match rand_wall_choose:
				0: # left/right walls
					enemy_instance.position = Vector2(rand_orientation[randi() % rand_orientation.size()] 
					* 1650, randf_range(-1,1) * 1150)
				1: # top/bottom walls
					enemy_instance.position = Vector2(randf_range(-1,1) * 1650, 
					rand_orientation[randi() % rand_orientation.size()]  * 1150)
			# Currently needing to figure out how to do this as a shared function for all types of scenes 
			# that are passed in as an input
			# I think I figured out how to do this. Make a string variable that keeps 
			# track of the name of the node, maybe as an export variable, and then
			# combine it together to get the full string name. Then, get the 
			# node accordingly. 
			var targeterNode = enemy_instance.get_node("EnemyPath/EnemyGuide/SmartPather/Targeter")
			var followNode = enemy_instance.get_node("EnemyPath/EnemyGuide/SmartPather/EMovementController/Follow")
			if targeterNode and followNode:
				target_manager(targeterNode, followNode)
			else:
				print("Node not found")
		add_child(enemy_instance)
		await $Timer.timeout
		if Global.enemyCount == max_enemies_on_screen:
			while !(Global.enemyCount < max_enemies_on_screen):
				print("Checking if max cap fulfilled wavemanager.gd")
				Global.enemyCount = Global.get_enemy_count()
				await get_tree().create_timer(2).timeout
		$Timer.start(spawn_timer)
	all_enemies_spawned = true
		

func _on_timer_timeout() -> void:
	#if intervals_passed < spawn_interval:
		#spawn_on_timer(enemy_bull_scene)
	#else:
		#all_enemies_spawned = true
	#spawn_on_timer(enemy_bull_scene)
	pass
	

func _process(delta: float) -> void:
	# want to do this if statement but I think there's definitely a more 
	# elegant way to do this that doesn't constantly check in the process
	
	# Slight unidentifiable bug where sometimes the enemy count dips below 0. If anyone 
	# has insight on this issue, lmk
	if Global.enemyCount <= 0 and waves_completed == num_waves - 1:
		Global.playerCurrHealth = Global.playerHealthNode.current_health
		print(Global.playerCurrHealth)
		# replace this with a check that spawns in reward and waits for the player to choose their reward
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/Map.tscn")
	elif Global.enemyCount <= 0 and waves_completed != num_waves - 1 and all_enemies_spawned:
		#intervals_passed = 0
		waves_completed += 1
		all_enemies_spawned = false
		spawn_on_timer(enemy_bull_scene)
		emit_signal("wave_changed")
