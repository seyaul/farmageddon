extends CharacterBody2D
class_name Snake

var can_take_damage: bool = true
@export var damage_cooldown: float = 0.2  # seconds

# TODO: Add way to manually tweak size of each point.
# TODO: Make head stop tweaking out or something idk.
@export var interact_with_environment: bool = false
@export var num_segments: int = 1
@export var segment_scale: float = 1
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

# TODO: Refactor to use a scene as a segment.
func segment_factory() -> Node2D:
	var node: Node2D
	if interact_with_environment:
		node = Segment.new()
		node.gravity_scale = 0
	else:
		node = Node2D.new()
	node.scale = node.scale * segment_scale
	node.took_damage.connect(take_damage)
	var collider: CollisionShape2D = CollisionShape2D.new()
	collider.shape = CircleShape2D.new()
	collider.scale *= 2
	collider.z_index = 100
	node.collision_layer = (1 << 2) | (1 << 3)
	node.add_child(collider)
	return node

func take_damage(damage: int) -> void:
	if not can_take_damage:
		return
	can_take_damage = false
	#print("took damage ", 2)
	$Health.take_damage(2)

	# Start cooldown to prevent more damage
	await get_tree().create_timer(damage_cooldown).timeout
	can_take_damage = true
	
	
func segments_factory() -> void:
	for i in range(num_segments):
		var segment = segment_factory()
		get_tree().current_scene.add_child.call_deferred(segment)
		segments.append(segment)

func make_segments_follow_each_other() -> void:
	segments[0].global_position = segments[0].global_position.lerp(global_position, stiffness)
	segments[0].global_rotation = global_rotation
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
