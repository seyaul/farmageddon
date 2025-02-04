extends Node

var map_data: Array = []
var floors_climbed: int = 0
var last_room: Room = null
var returning_from_stage: bool = false
var room_states: Dictionary = {}  #all of the states go here mwah
var player_died := false

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
				"available": false  
				}
			

func restore_room_states() -> void:
	for floor in map_data:
		for room in floor:
			var key = room.get_key()
			if key in room_states:
				room.selected = room_states[key]["selected"]
				
	if player_died:
		var first_room_key = map_data[0][0].get_key()
		if first_room_key in room_states:
			room_states[first_room_key]["selected"] = false
			room_states[first_room_key]["available"] = true


func reset_map_state() -> void:
	map_data = []
	floors_climbed = 0
	last_room = null
	returning_from_stage = false
	room_states.clear()
	player_died = true
	
	for key in room_states.keys():
		if key == "0,3":  
			room_states[key]["selected"] = false
			room_states[key]["available"] = true
		else:
			room_states[key]["available"] = false
