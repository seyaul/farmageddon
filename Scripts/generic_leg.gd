extends Node

# NOTE: Most of this is repeated code from leg.gd maybe refactor it to include this?
@export var source: Node2D
@export var leg_distance: float
@export var leg_spread: float
@export var speed: float

var leg1: Node2D
var leg2: Node2D

var start_pos1: Vector2
var start_pos2: Vector2
var step_pos1: Vector2
var step_pos2: Vector2

var moving: bool = false
@export var active_leg: int = 1  # 1 for leg1, 2 for leg2
var p1: float = 0
var p2: float = 0
@export var view_lines: bool
@export var line_width: float = 1

var line: Line2D

func _ready() -> void:
	leg1 = segment_factory()
	leg2 = segment_factory()
	if view_lines:
		line = Line2D.new()
		line.width = line_width
		get_tree().current_scene.add_child.call_deferred(line)
	get_tree().current_scene.add_child.call_deferred(leg1)
	get_tree().current_scene.add_child.call_deferred(leg2)
	
	


func _physics_process(delta: float) -> void:
	step_pos1 = source.to_global(Vector2(cos(deg_to_rad(leg_spread)), sin(deg_to_rad(leg_spread))).normalized() * leg_distance)
	step_pos2 = source.to_global(Vector2(cos(deg_to_rad(-1 * leg_spread)), sin(deg_to_rad(-1 * leg_spread))).normalized() * leg_distance)

	# Only allow the active leg to start moving
	if active_leg == 1 and leg1.position.distance_to(step_pos1) > leg_distance and not moving:
		start_pos1 = leg1.position
		moving = true
	if active_leg == 2 and leg2.position.distance_to(step_pos2) > leg_distance and not moving:
		start_pos2 = leg2.position
		moving = true

	# Move the legs based on the active_leg
	if moving:
		move_to_step(delta)
	if view_lines:
		line.points = [leg1.position, source.global_position, leg2.position]



func move_to_step(delta: float) -> void:
	if active_leg == 1:  # Move leg1
		p1 += delta * speed  # Increment progress over time
		p1 = clamp(p1, 0.0, 1.0)  # Keep progress between 0 and 1
		leg1.position = start_pos1.lerp(step_pos1, p1)
		if p1 == 1:  # When movement is complete
			p1 = 0
			moving = false
			active_leg = 2  # Switch to leg2
	else:  # Move leg2
		p2 += delta * speed # Increment progress over time
		p2 = clamp(p2, 0.0, 1.0)  # Keep progress between 0 and 1
		leg2.position = start_pos2.lerp(step_pos2, p2)
		if p2 == 1:  # When movement is complete
			p2 = 0
			moving = false
			active_leg = 1  # Switch to leg1
			
func segment_factory() -> Node2D:
	var node: Node2D = Node2D.new()
	var collider: CollisionShape2D = CollisionShape2D.new()
	collider.shape = CircleShape2D.new()
	node.add_child(collider)
	return node
