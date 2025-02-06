extends Node

# TODO: Move shooting logic to SnakeAttackController
# NOTE: For this boss we are only going to use the guns on the left side and front side.
# I am thinking of saving the right side for a second phase.
@export var gun: PackedScene
@export var bullet: PackedScene
@export var segments_with_gun: int = 1
var snake: Snake
var guns_connected: bool

func _ready() -> void:
	snake = get_parent()
	snake.ready.connect(_add_guns_to_legs)
	
func _add_guns_to_legs() -> void:
	for i in range(snake.num_segments):
		if i % segments_with_gun == 0:
			var segment = snake.segments[i]
			var script = load("res://Scripts/segment.gd")
			snake.segments[i].set_script(script)
			var gun1: Sprite2D = gun.instantiate()
			var gun2: Sprite2D = gun.instantiate()
			gun1.bullet = bullet
			gun2.bullet = bullet
			segment.lgun = gun1
			segment.rgun = gun2
			if i != 0:
				gun1.rotation_degrees = 0
				gun2.rotation_degrees = 180
			# TODO: Maybe add parameter values for this?
			elif i == 0:
				gun1.position -= Vector2(0, 10)
				gun2.position  += Vector2(0, 10)
			segment.add_child.call_deferred(gun1)
			segment.add_child.call_deferred(gun2)
	guns_connected = true
