extends Node2D

@export var enemy_bull_scene = preload("res://Scenes/smart_pather.tscn")
@export var enemy_chicken_scene = preload("res://Scenes/shooter.tscn")
#@export var player_scene = preload("res://Scenes/player.tscn")
var player_instance
#@onready var enemies = get_tree().get_nodes_in_group("enemies")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Global.numRuns += 1
	var music = get_node("AudioStreamPlayer")
	music.play()
	player_instance = Global.playerInstance
	add_child(player_instance)
	#player_instance.print_tree()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
