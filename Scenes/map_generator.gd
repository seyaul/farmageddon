
class_name MapGenerator
extends Node

const X_DIST := 30
const Y_DIST := 25
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 12
const MAP_WIDTH := 6
const PATHS := 6
const MONSTER_ROOM_WEIGHT := 12.0
const ELITE_ROOM_WEIGHT := 5.0
const SHOP_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0


var random_room_type_weights = {
	Room.Type.MONSTER: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHOP: 0.0,
	Room.Type.ELITE: 0.0
}
var random_room_type_total_weight := 0
var map_data: Array[Array]


func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
			
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()
	
	return map_data


func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_rooms: Array[Room]= []
		if i == 0:
			# Create a single room in the middle of the map width
			var single_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			single_room.position = Vector2(floor(MAP_WIDTH * 0.5) * X_DIST, i * -Y_DIST) + offset
			single_room.row = i
			single_room.column = floor(MAP_WIDTH * 0.5)
			single_room.next_rooms = []
			adjacent_rooms.append(single_room)
		else:
			for j in MAP_WIDTH:
				var current_room := Room.new()
				var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
				current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
				current_room.row = i
				current_room.column = j
				current_room.next_rooms = []
			
			# Boss room has a non-random Y
				if i == FLOORS - 1:
					current_room.position.y = (i + 1) * -Y_DIST
			
				adjacent_rooms.append(current_room)
			
		result.append(adjacent_rooms)

	return result


func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []

		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
			
			y_coordinates.append(starting_point)
		
	return y_coordinates


func _setup_connection(i: int, j: int) -> int:
	if i == 0:
		# Special case: if on the first floor, connect to all rooms on the second floor
		var first_room := map_data[0][0] as Room
		var next_room := map_data[1][floor(MAP_WIDTH * 0.5)] as Room
		first_room.next_rooms.append(next_room)
		return first_room.column
	else:
		var next_room: Room = null
		var current_room := map_data[i][j] as Room
	
		# Call existing path method to check if paths would cross
		while not next_room or _would_cross_existing_path(i, j, next_room):
			var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
			next_room = map_data[i + 1][random_j]
		
		current_room.next_rooms.append(next_room)
	
		return next_room.column


func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var left_neighbour: Room
	var right_neighbour: Room
	
	# If j == 0, there's no left neighbor
	if j > 0:
		left_neighbour = map_data[i][j - 1]
	# If j == MAP_WIDTH - 1, there's no right neighbor
	if j < MAP_WIDTH - 1:
		right_neighbour = map_data[i][j + 1]
	
	# Make sure we can't cross in right dir if right neighbor goes to left
	if right_neighbour and room.column > j:
		for next_room: Room in right_neighbour.next_rooms:
			if next_room.column < room.column:
				return true
	
	# Make sure we can't cross in left dir if left neighbor goes to right
	if left_neighbour and room.column < j:
		for next_room: Room in left_neighbour.next_rooms:
			if next_room.column > room.column:
				return true
	
	return false


func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[FLOORS - 1][middle] as Room
	
	for j in MAP_WIDTH:
		var current_room = map_data[FLOORS - 2][j] as Room
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)
			
	boss_room.type = Room.Type.BOSS	
	
func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	random_room_type_weights[Room.Type.CAMPFIRE] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.SHOP] = random_room_type_weights[Room.Type.CAMPFIRE] + SHOP_ROOM_WEIGHT
	random_room_type_weights[Room.Type.ELITE] = random_room_type_weights[Room.Type.SHOP] + ELITE_ROOM_WEIGHT

	random_room_type_total_weight = random_room_type_weights[Room.Type.ELITE]


func _setup_room_types() -> void:
	# Every room on the first floor is a monster room
	if map_data[0].size() > 0:
		map_data[0][0].type = Room.Type.MONSTER
				
	# Every room on the sixth floor is a treasure room
	for room: Room in map_data[5]:
		if room.next_rooms.size() > 0:
				room.type = Room.Type.TREASURE
				
	# Every room before the boss level is a campfire room
	for room: Room in map_data[FLOORS - 2]:
			room.type = Room.Type.CAMPFIRE
	
	# Logic for the rest of the rooms
	for current_floor in map_data:
		for room: Room in current_floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)


func _set_room_randomly(room_to_set: Room) -> void:
	var campfire_below_3 := true
	var consecutive_campfire := true
	var consecutive_shop := true
	var campfire_on_10 := true
	
	var type_candidate: Room.Type
	
	while campfire_below_3 or consecutive_campfire or consecutive_shop or campfire_on_10:
		type_candidate = _get_random_room_type_by_weight()
		
		var is_campfire := type_candidate == Room.Type.CAMPFIRE
		var has_campfire_parent := _room_has_parent_of_type(room_to_set, Room.Type.CAMPFIRE)
		var is_shop := type_candidate == Room.Type.SHOP
		var has_shop_parent := _room_has_parent_of_type(room_to_set, Room.Type.SHOP)
		
		campfire_below_3 = is_campfire and room_to_set.row < 2
		consecutive_campfire = is_campfire and has_campfire_parent
		consecutive_shop = is_shop and has_shop_parent
		campfire_on_10 = is_campfire and room_to_set.row == 9
		
	room_to_set.type = type_candidate

	#if type_candidate == Room.Type.MONSTER:
		#var tier_for_monster_rooms := 0
		#
		#if room_to_set.row > 1:
			#tier_for_monster_rooms = 1

func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents: Array[Room] = []
	
	# Ensure map_data has enough rows and columns before accessing
	if room.row > 0 and room.row - 1 < map_data.size():
		# Safeguard for the leftmost parent
		if room.column > 0 and room.column - 1 < map_data[room.row - 1].size():
			var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
			if parent_candidate.next_rooms.has(room):
				parents.append(parent_candidate)
		
		# Safeguard for the parent directly above
		if room.column < map_data[room.row - 1].size():
			var parent_candidate := map_data[room.row - 1][room.column] as Room
			if parent_candidate.next_rooms.has(room):
				parents.append(parent_candidate)
		
		# Safeguard for the rightmost parent
		if room.column + 1 < map_data[room.row - 1].size():
			var parent_candidate := map_data[room.row - 1][room.column + 1] as Room
			if parent_candidate.next_rooms.has(room):
				parents.append(parent_candidate)
	
	# Check if any parent matches the desired type
	for parent: Room in parents:
		if parent.type == type:
			return true
	
	return false


func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	return Room.Type.MONSTER
