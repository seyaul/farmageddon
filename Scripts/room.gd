class_name Room
extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, ELITE, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room] = []
@export var selected := false

func _init():
	next_rooms = []

func _to_string() -> String:
	return "%d,%d" % [row, column]

func get_key() -> String:
	return "%d,%d" % [row, column]
