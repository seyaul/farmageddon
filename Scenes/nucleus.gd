extends RigidBody2D

var ray: RayCast2D
func _ready() -> void:
	ray = get_node("RayCast2D")
	
func _physics_process(delta: float) -> void:
	pass
