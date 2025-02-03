extends Node

var map_data: Array = []
var floors_climbed: int = 0
var last_room: Room = null
var returning_from_stage: bool = false
var room_states: Dictionary = {}  #all of the states go here mwah

func save_map_state(data: Array, floors: int, last: Room) -> void:
	map_data = data
	floors_climbed = floors
	last_room = last
	returning_from_stage = true
	
	room_states.clear()
	for floor in data:
		for room in floor:
			var key = room.get_key()
			room_states[key] = {
				"selected": room.selected if room.selected != null else false,  # default to false if not set
				"available": false  # available key made for debugging purposes 
				}
			

func restore_room_states() -> void:
	for floor in map_data:
		for room in floor:
			var key = room.get_key()
			if key in room_states:
				room.selected = room_states[key]["selected"]


func reset_map_state() -> void:
	map_data = []
	floors_climbed = 0
	last_room = null
	returning_from_stage = false
	room_states.clear()
