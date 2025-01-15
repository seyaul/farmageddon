extends CollisionPolygon2D

@export var radius: float = 50
@export var segments: int = 16

func _ready() -> void:
	make_area()
	
func make_area() -> void:
	var points = []

	for i in range(segments + 1):
		var angle = PI * (i / float(segments))  # Semi-circle spans 180 degrees (PI radians)
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector2(x, -1 * y))

	# Close the semi-circle by adding the bottom edge
	points.append(Vector2(-radius, 0))
	points.append(Vector2(radius, 0))

	polygon = points
