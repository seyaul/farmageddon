extends Node

# TODO: Move shooting logic to SnakeAttackController
# NOTE: For this boss we are only going to use the guns on the left side and front side.
# I am thinking of saving the right side for a second phase.
@export var gun: PackedScene
@export var bullet: PackedScene
@export var segment_with_gun: int = 1
var body: Snake
var guns_connected: bool
var time: int

func _ready() -> void:
	body = get_parent()
	body.ready.connect(_add_guns_to_legs)
	
func _physics_process(delta: float) -> void:
	time += 1
	if guns_connected:
		shoot_guns(delta)
	
func _add_guns_to_legs() -> void:
	for i in range(body.num_segments):
		if i % segment_with_gun == 0:
			var segment = body.segments[i]
			var script = load("res://Scripts/segment.gd")
			body.segments[i].set_script(script)
			var gun1: Sprite2D = gun.instantiate()
			var gun2: Sprite2D = gun.instantiate()
			gun1.bullet = bullet
			gun2.bullet = bullet
			segment.lgun = gun1
			segment.rgun = gun2
			if i != 0:
				gun1.rotation_degrees = 0
				gun2.rotation_degrees = 180
			segment.add_child.call_deferred(gun1)
			segment.add_child.call_deferred(gun2)
	guns_connected = true
	
func shoot_guns(delta: float) -> void:
	for i in range(body.num_segments):
		if i % segment_with_gun == 0:
			var segment = body.segments[i]
			if time % 10 == 0 and i % 2 == 0:
				segment.lgun.fire(delta)
			if time % 5 == 0 and i % 2 != 0:
				segment.lgun.fire(delta)
