extends Node2D

@export var node_name : String = "SmartPather"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
