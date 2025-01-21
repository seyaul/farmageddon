extends Node

func _ready():
	var map_generator = $MapGenerator
	var map_display = $MapDisplay
	
	# Generate a map (plane_len, node_count, path_count)
	var map_data = map_generator.generate(1000, 20, 3)
	
	# Display the generated map
	map_display.display_map(map_data)
