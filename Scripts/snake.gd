extends Node2D


# TODO: Add way to manually tweak size of each point.
@export var num_segments: int = 1
@export_range(0.0,1.0)
var stiffness: float

var segments: Array[Node2D] = []
var is_ready: bool

@export var distance: float
@export var view_lines: bool
@export var line_width: float = 1

var line: Line2D

func _ready() -> void:
	segments_factory()
	if view_lines:
		line = Line2D.new()
		line.width = line_width
		get_tree().current_scene.add_child.call_deferred(line)
	is_ready = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	make_head_follow_mouse()
	make_segments_follow_each_other()
	
	if view_lines:
		draw_lines()

func segment_factory() -> Node2D:
	var node: Node2D = Node2D.new()
	var collider: CollisionShape2D = CollisionShape2D.new()
	collider.shape = CircleShape2D.new()
	node.add_child(collider)
	return node
	
func segments_factory() -> void:
	for i in range(num_segments):
		var segment = segment_factory()
		get_tree().current_scene.add_child.call_deferred(segment)
		segments.append(segment)

# TODO: Copied this from mouefollower, change this or mousefollower later.
func make_head_follow_mouse() -> void:
	var mouse_position := get_global_mouse_position()
	position = mouse_position
	look_at(mouse_position)
	
func make_segments_follow_each_other() -> void:
	segments[0].position = segments[0].position.lerp(position, stiffness)
	segments[0].look_at(position)
	# Each subsequent point follows the one before it
	for i in range(1, segments.size()):
		var current_node = segments[i]
		var prev_node = segments[i - 1]

		# Calculate the desired position based on the previous node
		var direction = (current_node.position - prev_node.position).normalized()
		var desired_position = prev_node.position + direction * distance

		# Smoothly move towards the desired position
		current_node.position = current_node.position.lerp(desired_position, stiffness)
		current_node.look_at(prev_node.position)
		
func draw_lines() -> void:
	line.clear_points()
	for i in range(segments.size()):
		var current_node = segments[i]
		line.add_point(current_node.position)
