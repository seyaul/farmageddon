extends State
class_name DashState


@export var dash_to_mouse: bool = false
@export var phase_on_dash: bool = false
@export var max_dashes: int = 1
@export var dash_cooldown: int = 1
@export var max_distance: float = 500
@export var dash_speed: float = 5

var character: CharacterBody2D
var collider: CollisionShape2D

var dashes: int
#TODO: Replace with timer? 
var time: int = 0
var initial_position: Vector2
var target_position: Vector2

# Called when the node enters the scene tree for the first time.
func Enter():
	character = get_parent().get_parent()
	collider = character.get_node("Collider")
	initial_position = character.position
	# If character isn't moving, dash towards mouse
	if dash_to_mouse or character.velocity == Vector2.ZERO:
		target_position = character.get_global_mouse_position()
	else:
		target_position = character.position + character.velocity.normalized() * max_distance

	
func Update(delta: float):
	if dashes <= 0:
		emit_signal("state_transition", self, "Walk")
		# TODO: Change this
	elif (round(character.position / 10) - round(target_position / 10)).length() > 5 and \
		character.position.distance_to(initial_position) < max_distance:
		if phase_on_dash:
			collider.disabled = true
		var dir = (target_position - character.position).normalized()
		character.velocity = dir * dash_speed * delta
		print("Dashing ", round(target_position/ 10), "  ", round(character.position / 10), " ", round(character.position / 10) != round(target_position/ 10))
		# Use move_and_slide to move and detect collisions
		character.move_and_slide()
		dashes -= 1
	else:
		emit_signal("state_transition", self, "Walk")
	
func Exit():
	collider.disabled = false
	collider = null
	
func _ready() -> void:
	dashes = max_dashes
	
func _physics_process(_delta: float) -> void:
	time += 1
	if time % dash_cooldown == 0 && dashes < max_dashes:
		dashes += 1