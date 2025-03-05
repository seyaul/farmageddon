extends Node

# NOTE: This script will be deprecated once the snake script is refactored.
@export var texture: Texture2D
@export_enum("Odd", "Even", "Custom") 
var segments_with_texture: String
@export var every_segment:int = 1
@export var offset_degrees: float = 90
@export var x_offset: float
@export var y_offset: float
var snake: Snake

func _ready() -> void:
	snake = get_parent()
	snake.ready.connect(_add_textures_to_segments)

# TODO: Make segment selection more sophisticated.
func _add_textures_to_segments() -> void:
	if segments_with_texture == "Custom":
		for i in range(1, snake.num_segments, every_segment):
			add_texture_to_segment(i)
	else:
		for i in range(1, snake.num_segments):
			if segments_with_texture == "Odd" and i % 2 != 0 or \
			segments_with_texture == "Even" and i % 2 == 0:
				add_texture_to_segment(i)

# TODO: Fix parameters for this
func add_texture_to_segment(i: int) -> void:
	var sprite: Sprite2D = Sprite2D.new()
	sprite.z_index = snake.segments.size() - i
	sprite.z_as_relative = false
	print(snake.segments.size() - i)
	sprite.scale = sprite.scale * 2
	sprite.texture = texture
	sprite.rotation_degrees += offset_degrees
	sprite.position.x += x_offset
	sprite.position.y += y_offset
	snake.segments[i].add_child(sprite)
	
