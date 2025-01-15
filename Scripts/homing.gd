extends AnimatableBody2D

@export var speed: float = 100
@export var homing_target: Node2D
var homing_pos
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_collide(constant_linear_velocity * delta)
	homing_pos = homing_target.position
	var direction = (homing_pos - position).normalized() 
	if position.distance_to(homing_pos) > 100000:
		constant_linear_velocity = direction * speed  # Set velocity based on direction and speed
	else:
		constant_linear_velocity = Vector2.ZERO  # Stop moving if within range
