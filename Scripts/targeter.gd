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
		#print(target, " target in targeter.gd")
		if is_instance_valid(target) and is_instance_valid(aimer):
			dist = target.global_position - aimer.global_position
			if abs(dist.x) > abs(dist.y):
				if dist.x >= 0:
					animatedSprite.play("rightFacingWalk")
				else:
					animatedSprite.play("leftFacingWalk")
			elif abs(dist.x) < abs(dist.y):
				if dist.y >= 0:
					animatedSprite.play("frontFacingWalk")
				else: 
					animatedSprite.play("backFacingWalk")
		elif !is_instance_valid(target):
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
			
		#aimer.look_at(target.global_position)
		#aimer.rotation_degrees += offset_rotation
