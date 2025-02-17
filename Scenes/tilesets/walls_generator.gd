#extends Node2D
#
#@export var walls_tilemap_layer: TileMap
#@export var wall_tile_id: int = 0  # The wall tile ID
#@export var grid_width: int = 70  # Grid width
#@export var grid_height: int = 39  # Grid height
#
#func _ready():
	#generate_random_walls()
#
#func generate_random_walls():
	#for i in range(4):  # Number of walls to generate (4 walls)
		#var wall_width = 2  # Width of each wall in tiles (2x2)
		#var wall_height = 2  # Height of each wall in tiles
#
		## Randomly choose a starting position for the wall (ensuring the wall fits within the grid)
		#var start_x = int(randf_range(0, grid_width - wall_width))
		#var start_y = int(randf_range(0, grid_height - wall_height))
#
		#print("Generated wall at: ", start_x, start_y, " with size: 2x2")
#
		## Loop to place the 2x2 wall tiles
		#for x in range(wall_width):
			#for y in range(wall_height):
				## Place the tile at the correct position using Vector2i
				#walls_tilemap_layer.set_cell(Vector2i(start_x + x, start_y + y), wall_tile_id)
				##print("Placing wall tile at: ", start_x + x, start_y + y)  # Debug print
