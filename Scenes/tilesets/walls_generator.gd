extends Node2D

@export var walls_tilemap_layer: TileMapLayer
@export var wall_tile_id: int= 2
@export var grid_width: int = 70
@export var grid_height: int = 39

func _ready():
	#generate_random_walls()
	pass

# Function to generate random walls
func generate_random_walls():
	#for i in range(4):  # number of walls to generate
		## random dimensions for the wall (2x2 to 20x2 or 2x2 to 2x20)
		#var wall_width = int(randf_range(2, 20))
		#var wall_height = int(randf_range(2, 20))
#
		## random starting position for wall
		#var start_x = int(randf_range(0, grid_width - wall_width))
		#var start_y = int(randf_range(0, grid_height - wall_height))
		#print("Wall generated at: ", start_x, start_y)
#
		## place wall tiles on the grid in Walls
		#for x in range(wall_width):
			#for y in range(wall_height):
				#walls_tilemap_layer.set_cell(Vector2(start_x + x, start_y + y), wall_tile_id)
				#print("Placed tile at: ", start_x + x, start_y + y)
	pass
