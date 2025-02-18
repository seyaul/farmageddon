extends CharacterBody2D
class_name Snake

# TODO: Add way to manually tweak size of each point.
# TODO: Make head stop tweaking out or something idk.
# TODO: Separate texturing of snake from this script.
@export var texture: Texture2D
@export var interact_with_environment: bool = false
@export var num_segments: int = 1
@export_range(0.0,1.0)
var stiffness: float

var segments: Array[Node2D] = []

@export var distance: float
@export var view_lines: bool
@export var connect_head: bool
@export var line_width: float = 1

var line: Line2D

var idk: int = 1

func _ready() -> void:
	segments_factory()
	if view_lines:
		line = Line2D.new()
		line.width = line_width
		get_tree().current_scene.add_child.call_deferred(line)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	make_segments_follow_each_other()
	if view_lines:
		draw_lines()

func segment_factory() -> Node2D:
	var node
	if interact_with_environment:
		node = RigidBody2D.new()
		node.gravity_scale = 0
		node.global_position = global_position
	else:
		node = Node2D.new()
	var collider: CollisionShape2D = CollisionShape2D.new()
	var sprite: Sprite2D = Sprite2D.new()
	collider.shape = CircleShape2D.new()
	sprite.texture = texture
	node.add_child(collider)
	node.add_child(sprite)
	return node
	
func segments_factory() -> void:
	for i in range(num_segments):
		var segment = segment_factory()
		get_tree().current_scene.add_child.call_deferred(segment)
		segments.append(segment)

func make_segments_follow_each_other() -> void:
	segments[0].position = segments[0].position.lerp(global_position, stiffness)
	segments[0].look_at(global_position)
	# Each subsequent point follows the one before it
	for i in range(1, segments.size()):
		var current_node = segments[i]
		var prev_node = segments[i - 1]

		# Calculate the desired position based on the previous node
		var direction = (current_node.global_position - prev_node.global_position).normalized()
		var desired_position = prev_node.position + direction * distance

		# Smoothly move towards the desired position
		current_node.global_position = current_node.global_position.lerp(desired_position, stiffness)
		current_node.look_at(prev_node.global_position)
		
func draw_lines() -> void:
	line.clear_points()
	for i in range(segments.size()):
		var current_node = segments[i]
		line.add_point(current_node.global_position)
	if connect_head:
		line.add_point(global_position, 0)
