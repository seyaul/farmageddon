extends Node

@export var target: Node2D
@export var offset_rotation: float
@export var player: bool
var animatedSprite: AnimatedSprite2D
var aimer: Node2D
var dist: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aimer = get_parent()
	# Better way to do this? Bad coding practice
	if(aimer.get_node("EnemySprite") != null):
		animatedSprite = aimer.get_node("EnemySprite")
		player = false
	elif(aimer.get_node("CharacterSprite") != null):
		animatedSprite = aimer.get_node("CharacterSprite")
		player = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not player:
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
	else: 
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or \
		   Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
			if Input.is_action_pressed("move_left"):
				animatedSprite.play("leftFacingWalk")
			elif Input.is_action_pressed("move_right"):
				animatedSprite.play("rightFacingWalk")
			elif Input.is_action_pressed("move_up"):
				animatedSprite.play("backFacingWalk")
			elif Input.is_action_pressed("move_down"):
				animatedSprite.play("frontFacingWalk")
			else:
				print("undefined behavior")
				
		#aimer.look_at(target.global_position)
		#aimer.rotation_degrees += offset_rotation
