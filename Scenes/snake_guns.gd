extends Node

@export var gun: PackedScene
@export var bullet: PackedScene
var body: Snake


func _ready() -> void:
	body = get_parent()
	body.ready.connect(_add_guns_to_legs)
	
func _add_guns_to_legs() -> void:
	for i in range(body.num_segments):
		if i % 2 == 0:
			var script = load("res://Scripts/segment.gd")
			body.segments[i].set_script(script)
			var curr_gun1: Sprite2D = gun.instantiate()
			var curr_gun2: Sprite2D = gun.instantiate()
			curr_gun1.bullet = bullet
			curr_gun2.bullet = bullet
			print(curr_gun1.rotation_degrees)
			curr_gun1.rotation_degrees = 0
			curr_gun2.rotation_degrees = 180
			body.segments[i].add_child.call_deferred(curr_gun1)
			body.segments[i].add_child.call_deferred(curr_gun2)
