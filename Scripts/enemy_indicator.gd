extends Control

@export var target: Node2D
@export var player: Node2D
@export var camera: Camera2D
@export var max_distance: float = 2000.0
@export var screen_margin: float = 30.0

func ready():
	visible = false

func _process(_delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	set_marker_position(camera.get_viewport_rect())
	if !is_instance_valid(target) or !is_instance_valid(player) or !is_instance_valid(camera):
		return
	
	# Fade by distance (optional)
	var dist = player.global_position.distance_to(target.global_position)
	var alpha = clamp(1.0 - (dist / max_distance), 0.3, 1.0)
	modulate.a = alpha
func set_marker_position(bounds: Rect2):
	#$indicator.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
	#$indicator.global_position.y = clamp(global_position.y, bounds.position.x, bounds.end.y)
	if !is_instance_valid(target) or !is_instance_valid(player):
		visible = false
		return

	# Viewport setup
	var viewport_size = get_viewport().get_visible_rect().size
	var half_viewport = viewport_size * 0.5
	var player_pos = player.global_position
	var visible_rect = Rect2(player_pos - half_viewport, viewport_size)

	# Check if the enemy is on screen (within the player-centered screen bounds)
	if visible_rect.has_point(target.global_position):
		visible = false
		return
	else:
		visible = true

	# Direction from player to enemy
	var direction = (target.global_position - player.global_position).normalized()
	rotation = direction.angle() - PI / 2  # Adjust for sprite orientation

	# Position arrow on edge of screen, in UI space
	var screen_center = viewport_size * 0.5
	var scale_x = abs(screen_center.x / direction.x) if direction.x != 0 else 999999
	var scale_y = abs(screen_center.y / direction.y) if direction.y != 0 else 999999
	var scale = min(scale_x, scale_y)
	var edge_offset = direction * scale * 0.95
	position = screen_center + edge_offset
	visible = true

	# Fade based on distance
	var distance = player.global_position.distance_to(target.global_position)
	modulate.a = clamp(1.0 - (distance / max_distance), 0.1, 1.0)
