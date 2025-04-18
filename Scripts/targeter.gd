extends Node

@export var target: Node2D
@export var offset_rotation: float
@export var disabled: bool
var animatedSprite: AnimatedSprite2D
var aimer: Node2D
var dist: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aimer = get_parent()
	print(aimer, " debugging for big")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	## Target not loaded in 
	if not disabled:
		if is_instance_valid(target):
			aimer.look_at(target.global_position)
			aimer.rotation_degrees += offset_rotation
		else:
			await get_tree().process_frame
