extends Node2D

# TODO: Refactor to be in a state machine with the gun
# NOTE: Logic is commented out because im not sure how the actual melee will work.
@export var melee_weapon: PackedScene
'''
@export var arc: float = 0
@export var arc_speed: float = 0
'''
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().melee.connect(strike)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	'''
	if Input.is_action_just_pressed("melee"):
		strike()
	if melee_weapon.is_enabled() and rotation_degrees < arc / 2:
		if rotation_degrees + arc_speed > arc / 2:
			rotation_degrees = arc / 2
		else:
			rotate(deg_to_rad(arc_speed))
	#print(rotation_degrees)
	'''
	pass

		
func strike() -> void:
	rotation_degrees = 0
	var melee = melee_weapon.instantiate()
	get_parent().add_child(melee)
	'''
	#rotate(deg_to_rad(-1 * arc / 2))
	'''

	

	
	
