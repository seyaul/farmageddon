extends Node2D

@export var enemy_bull_scene = preload("res://Scenes/smart_pather.tscn")
@export var enemy_chicken_scene = preload("res://Scenes/shooter.tscn")
#@export var player_scene = preload("res://Scenes/player.tscn")
var player_instance
#@onready var enemies = get_tree().get_nodes_in_group("enemies")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.numRuns += 1
	var music = get_node("AudioStreamPlayer")
	music.play()
	player_instance = Global.playerInstance
	add_child(player_instance)
	#player_instance.print_tree()
	for i in range(20):
		var chicken_instance = enemy_chicken_scene.instantiate()
		var bull_instance = enemy_bull_scene.instantiate()
		#enemy_instance.print_tree() (GOATED FUNCTION)
		if chicken_instance and bull_instance is Node2D:
			chicken_instance.position = Vector2(randf_range(-1,1)* 700, randf_range(-1,1) * 300)
			bull_instance.position = Vector2(randf_range(-1,1)* 700, randf_range(-1,1) * 300)
			var targeterNodeChicken = bull_instance.get_node("EnemyPath/EnemyGuide/SmartPather/Targeter")
			var followNodeChicken = bull_instance.get_node("EnemyPath/EnemyGuide/SmartPather/EMovementController/Follow")
			var targeterNodeBull = chicken_instance.get_node("EnemyPath/EnemyGuide/Shooter/Targeter")
			var followNodeBull = chicken_instance.get_node("EnemyPath/EnemyGuide/Shooter/EMovementController/Follow")
			if targeterNodeChicken and followNodeChicken:
				target_manager(targeterNodeChicken, followNodeChicken)
				target_manager(targeterNodeBull, followNodeBull)
			else:
				print("Node not found")
		add_child(chicken_instance)
		add_child(bull_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		# Slight unidentifiable bug where sometimes the enemy count dips below 0. If anyone 
		# has insight on this issue, lmk
		if Global.enemyCount <= 0:
			Global.playerCurrHealth = Global.playerHealthNode.current_health
			print(Global.playerCurrHealth)
			# replace this with a check that spawns in reward and waits for the player to choose their reward
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://Scenes/Map.tscn")

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
