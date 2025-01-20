extends Node2D

# TODO: Add way to manually tweak size of each point.
@export var num_segments: int = 1
@export_range(0.0,1.0)
var stiffness: float

var segments: Array[Node2D] = []

@export var distance: float
@export var view_lines: bool
@export var line_width: float = 10

var lines: Array[Line2D] = []

@export var legged_segments: Array[int]
@export var leg_distance: float
@export var leg_spread: float


func _ready() -> void:
	segments_factory()
	legs_factory()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	make_head_follow_mouse()
	make_segments_follow_each_other()

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
		if view_lines and i != 0:
			var line = Line2D.new()
			line.width = line_width
			get_tree().current_scene.add_child.call_deferred(line)
			lines.append(line)

func legs_factory() -> void:
	for i in legged_segments:
		var leg1 = segment_factory()
		var leg2 = segment_factory()
		segments[i].add_child(leg1)
		segments[i].add_child(leg2)
		leg1.position = Vector2(cos(deg_to_rad(leg_spread)), sin(deg_to_rad(leg_spread))).normalized() * leg_distance
		leg2.position =  Vector2(cos(deg_to_rad(-1 * leg_spread)), sin(deg_to_rad(-1 * leg_spread))).normalized() * leg_distance
		
	
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
		if view_lines:
			lines[i - 1].points = [prev_node.position, current_node.position]
		
		
