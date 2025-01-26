extends PathFollow2D

@export var enemy_chicken_scene = preload("res://Scenes/smartPather.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		var enemy_instance = enemy_chicken_scene.instantiate()
		#print(enemy_instance)
		#print(enemy_instance.get_tree().root)
		if enemy_instance is Node2D:
			enemy_instance.position = Vector2(randf() * 500, randf() * 300)
			if enemy_instance.has_node("Targeter"):
				var targeter = enemy_instance.get_node("Targeter")
				#print(targeter)
				targeter.target = $"../../Player"
				#print(targeter.target)
			else:
				#print("Missing node")
				pass
		add_child(enemy_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
