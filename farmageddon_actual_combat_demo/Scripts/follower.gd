extends AnimatableBody2D

@export var speed: float = 100
@export var follow_target: Node2D

var navigation: NavigationAgent2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation = get_node("NavigationAgent2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	makepath()
	var dir = (navigation.get_next_path_position() - position).normalized()
	constant_linear_velocity = dir * speed
	move_and_collide(delta * constant_linear_velocity)
	
func makepath() -> void:
	navigation.target_position = follow_target.global_position
