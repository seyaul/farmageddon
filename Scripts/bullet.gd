extends AnimatableBody2D

# TODO: Fix sticky behavior
@export_enum("Bouncy", "Sticky")
var collision_behavior: String = "Bouncy"

@export var bounces_til_despawn: int = 1
# WARNING: Too many bullets in the scene causes lag.
@export var life_span: int = 100
@export var max_range: int = 100
# WARNING: Slow moving objects won't be detected for collisions with a low safe margin.
# NOTE: Higher safe margin is used for preventing multi-collisions and penetration for fast moving objects.
@export var safe_margin: float = 1

var curr_collisions: int = 0
#TODO: Replace with timer?
var time: int = 0
var initial_position: Vector2
var last_collision_time: int = 0


func _ready() -> void:
	initial_position = position
	if name == "Fragment":
		print("spawned")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	time += 1
	if time >= life_span:
		queue_free()
	if initial_position.distance_to(position) >= max_range:
		constant_linear_velocity = Vector2.ZERO
	var collision = move_and_collide(constant_linear_velocity * delta, false, safe_margin)
	if collision:
		_handle_collisions(collision)
	
	

func _handle_collisions(collision: KinematicCollision2D) -> void:
	print("detected")
	if collision_behavior == "Sticky":
		constant_linear_velocity = Vector2.ZERO
	elif collision_behavior == "Bouncy":
		var current_collision_time = Time.get_ticks_msec()
		if bounces_til_despawn > 0:
			constant_linear_velocity = constant_linear_velocity.bounce(collision.get_normal())
			bounces_til_despawn -= 1
		else:
			queue_free()
			
			
			
