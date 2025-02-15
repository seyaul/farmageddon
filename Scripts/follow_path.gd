extends State

@export var speed: float = 0.1
@export var backwards: bool = false
@export var should_reverse: bool = false
@export var pause_time: float = 0
@export var time_following: int
@export var attach_position_to: Node2D
@export var slide_speed: float
# Called when the node enters the scene tree for the first time.
var enemy: CharacterBody2D
var guide: PathFollow2D
var path: Path2D
var paused: bool = false
var paused_for: float = 0
var animation: AnimatedSprite2D
var time: int

func Enter():
	enemy = self.get_parent().get_parent()
	guide = enemy.get_parent()
	path = guide.get_parent()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Update(delta: float) -> void:
	time += 1
	#Attaches path position to a node if it is present.
	if is_instance_valid(attach_position_to):
		path.global_position = path.global_position.lerp(attach_position_to.global_position, slide_speed * delta)
	# In case enemy deviates from path by accident, return back to path.
	if guide.global_position - enemy.global_position != Vector2.ZERO:
		emit_signal("state_transition", self, "Return")
	if paused:
		_pause_enemy()
		return
	_move_enemy(delta)
	# Reinitializes state when it is no longer following the path.
	if time >= time_following:
		attach_position_to = null
		backwards = false
		path.global_position = Vector2.ZERO
		emit_signal("state_transition", self, "Follow")
		

func Exit() -> void:
	time = 0

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

func _pause_enemy() -> void:
	paused_for += 1
	if paused_for >= pause_time:
		paused = false
		paused_for = 0
