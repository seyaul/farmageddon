extends Node

@export var indicator_scene: PackedScene = preload("res://Scenes/enemy_indicator.tscn")
@export var player: Node2D
@export var camera: Camera2D

var indicators := {}

func _ready():
	player = Global.playerInstance
func _process(_delta):
	var enemies = get_tree().get_nodes_in_group("enemies")

	# Remove stale indicators
	for enemy in indicators.keys():
		if !enemies.has(enemy) or !is_instance_valid(enemy):
			indicators[enemy].queue_free()
			indicators.erase(enemy)

	# Add indicators for new enemies
	for enemy in enemies:
		if !indicators.has(enemy):
			var arrow = indicator_scene.instantiate()
			arrow.target = enemy
			arrow.player = player
			arrow.camera = camera
			add_child(arrow)
			indicators[enemy] = arrow
