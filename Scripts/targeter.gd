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
	# Better way to do this? Bad coding practice
	if aimer.has_node("EnemySprite2"):
		animatedSprite = aimer.get_node("EnemySprite2")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not disabled:
		if animatedSprite:
			animatedSprite.play("walk")
		aimer.look_at(target.global_position)
		aimer.rotation_degrees += offset_rotation