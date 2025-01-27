extends Node2D

signal all_enemies_cleared

@onready var enemies = get_tree().get_nodes_in_group("enemies")

func _ready() -> void:
	print(enemies.size(), " enemies remain!")
	for enemy in enemies:
		var health_node = enemy.get_node("Health")
		if health_node and health_node.has_signal("character_died"):
			health_node.connect("character_died", Callable(self, "_on_enemy_died"))
			print("connected to character_died signal for ", enemy.name) 

func _on_enemy_died(enemy_health: Node) -> void:
	print("enemy signal recieved for: ", enemy_health.get_parent().name)
	enemies.erase(enemy_health.get_parent()) 
	print("enemies left: ", enemies.size())
	if enemies.size() == 1:  
		emit_signal("all_enemies_cleared")

func _on_all_enemies_cleared():
	print("switching to map scene...")
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
