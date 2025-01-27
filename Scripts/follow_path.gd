extends State

@export var aggro_target: CharacterBody2D
@export var speed: float = 0.1
@export var should_reverse: bool = false
@export var pause_time: float = 0
@export var can_aggro: bool = false
@export var aggro_distance: float = 600
# Called when the node enters the scene tree for the first time.
var enemy: CharacterBody2D
var guide: PathFollow2D
var backwards: bool = false
var paused: bool = false
var paused_for: float = 0
var animation: AnimatedSprite2D

func Enter():
	enemy = self.get_parent().get_parent()
	guide = enemy.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Update(delta: float) -> void:
	if can_aggro and enemy.global_position.distance_to(aggro_target.global_position) <= aggro_distance:
		emit_signal("state_transition", self, "Follow")
	if guide.global_position - enemy.global_position != Vector2.ZERO:
		emit_signal("state_transition", self, "Return")	
	if paused:
		_pause_enemy()
		return
	_move_enemy(delta)
	
	

func Exit() -> void:
	pass

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
