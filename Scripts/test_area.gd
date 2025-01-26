extends Node2D

@export var enemy_bull_scene = preload("res://Scenes/smart_pather.tscn")
@export var enemy_chicken_scene = preload("res://Scenes/shooter.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(30):
		var chicken_instance = enemy_chicken_scene.instantiate()
		var bull_instance = enemy_bull_scene.instantiate()
		#enemy_instance.print_tree() (GOATED FUNCTION)
		if chicken_instance and bull_instance is Node2D:
			chicken_instance.position = Vector2(randf_range(-1,1)* 1000, randf_range(-1,1) * 500)
			bull_instance.position = Vector2(randf_range(-1,1)* 1000, randf_range(-1,1) * 500)
			var targeterNodeChicken = bull_instance.get_node("EnemyPath/EnemyGuide/SmartPather/Targeter")
			var followNodeChicken = bull_instance.get_node("EnemyPath/EnemyGuide/SmartPather/EMovementController/Follow")
			var targeterNodeBull = chicken_instance.get_node("EnemyPath/EnemyGuide/Shooter/Targeter")
			var followNodeBull = chicken_instance.get_node("EnemyPath/EnemyGuide/Shooter/EMovementController/Follow")
			if targeterNodeChicken and followNodeChicken:
				targeterNodeChicken.target = $Player
				followNodeChicken.follow_target = $Player
				targeterNodeBull.target = $Player
				followNodeBull.follow_target = $Player
			else:
				print("Node not found")
		add_child(chicken_instance)
		add_child(bull_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
