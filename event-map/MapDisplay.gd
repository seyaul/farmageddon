extends Node2D

var map_data  # Declare the variable at class level

func display_map(new_map_data):
	# Clear previous drawings
	queue_redraw()  # Changed from update() to queue_redraw()
	
	# Store the map data for drawing
	map_data = new_map_data
	
func _draw():
	if not map_data:
		return
		
	# Draw all points
	for point in map_data.points:
		draw_circle(point, 5, Color.WHITE)  # Changed from Color.white to Color.WHITE
	
	# Draw all paths
	for path in map_data.paths:
		for i in range(path.size() - 1):
			var start_point = map_data.points[path[i]]
			var end_point = map_data.points[path[i + 1]]
			draw_line(start_point, end_point, Color.RED, 2.0)  # Changed from Color.red to Color.RED
