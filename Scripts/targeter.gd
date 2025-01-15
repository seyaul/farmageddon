extends Node

@export var target: Node2D
@export var offset_rotation: float
var aimer: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aimer = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	aimer.look_at(target.global_position)
	aimer.rotation_degrees += offset_rotation
