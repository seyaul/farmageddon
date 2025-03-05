extends State

@export var next_state: String
@export var return_state: String
@export var guide: PathFollow2D
@export var path: Path2D
@export var look_at_player: bool
@export var speed: float = 0.1
@export var backwards: bool = false
@export var should_reverse: bool = false
@export var pause_time: float = 0
@export var time_following: int
@export var attach_position_to: Node2D
@export var slide_speed: float
@export var tolerance: float
# Called when the node enters the scene tree for the first time.
var enemy: CharacterBody2D
var paused: bool = false
var paused_for: float = 0
var animation: AnimatedSprite2D
var time: int
var targeter: Node

var previous_position: Vector2

func Enter():
	if targeter && not look_at_player:
		targeter.disabled = true

func _physics_process(delta: float) -> void:
	#if name == "Wander":
	#	print(enemy.global_position, "   ", guide.global_position)
	return
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Update(delta: float) -> void:
	time += 1
	if paused:
		_pause_enemy()
		return
	# In case enemy deviates from path by accident, return back to path.
	if guide.global_position.distance_to(enemy.global_position) > tolerance:
		emit_signal("state_transition", self, return_state)
	else:
		#Attaches path position to a node if it is present.
		_move_path(delta)
		_move_enemy(delta)
		# Reinitializes state when it is no longer following the path.
		if time >= time_following:
			attach_position_to = null
			backwards = false
			path.global_position = Vector2.ZERO
			emit_signal("state_transition", self, next_state)
			return

func Exit() -> void:
	time = 0
	if targeter:
		targeter.disabled = false
		
func _ready() -> void:
	enemy = self.get_parent().get_parent()
	targeter = enemy.get_node("Targeter")

# TODO: Decouple guide moving from moving enemy. 
func _move_enemy(delta: float) -> void:
	if backwards:
		guide.progress_ratio -= delta * speed
		#enemy.rotation_degrees += 180
		if should_reverse and guide.progress_ratio <= .05:
			backwards = not backwards
			paused = pause_time > 0
	else:
		guide.progress_ratio += delta * speed
		if should_reverse and guide.progress_ratio >= .95:
			backwards = not backwards
			paused = pause_time > 0
	if not look_at_player and not is_instance_valid(attach_position_to):
		enemy.rotation = guide.rotation
	elif not look_at_player:
		enemy.rotation = guide.rotation + deg_to_rad(180)
	enemy.global_position = guide.global_position

func _pause_enemy() -> void:
	paused_for += 1
	if paused_for >= pause_time:
		paused = false
		paused_for = 0

func _move_path(delta: float) -> void:
	if is_instance_valid(attach_position_to):
		path.global_position = path.global_position.lerp(attach_position_to.global_position, slide_speed * delta)
