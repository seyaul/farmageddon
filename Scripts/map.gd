class_name Map
extends Node2D

const SCROLL_SPEED := 100
const MAP_ROOM = preload("res://Scenes/room.tscn")
const MAP_LINE = preload("res://Scenes/line.tscn")

@onready var map_generator: MapGenerator = $MapGenerator
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var visuals: Node2D = $Visuals
@onready var camera_2d: Camera2D = $Camera2D
@onready var map_background = $MapBackground


var map_data: Array[Array]
var floors_climbed: int
var last_room: Room
var camera_edge_y: float
var scroll_direction: int
var camera_y_pos : int
var god_mode_enabled: bool = false

func _ready() -> void:
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS - 1)
	
	# campfire node/signal stuff
	Global.connect("campfire_selected", Callable(self, "_on_campfire_selected"))
	Global.connect("newGameStarted", Callable(self, "_on_new_game_started"))

	# make sure the node has been freed so two instances dont spawn
	if Global.map_tutorial:
		var existing_tutorial = map_background.get_node_or_null("MapTutorialInterface")
		if existing_tutorial:
			var monster_prompt = existing_tutorial.get_node_or_null("MonsterPrompt")
			if monster_prompt:
				monster_prompt.visible = false
			existing_tutorial.queue_free()
			await get_tree().process_frame

	# transition to this checking if it is within a Global group of rooms 
	if GameState.returning_from_stage and !Global.newGame:
		#print("Returning to the same map...")
		load_map(GameState.map_data, GameState.floors_climbed, GameState.last_room)
		Global.map_tutorial = false
	else:
		generate_new_map()
		if Global.newGame or GameState.player_died:
			GameState.player_died = false
			unlock_floor(0)
	unlock_floor(0)

	if Global.newGame and not Global.map_tutorial_has_run:
		Global.map_tutorial = true
	else:
		Global.map_tutorial = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("scroll_up") or Input.is_action_pressed("move_up"):
		scroll_direction = -1
	elif Input.is_action_pressed("scroll_down") or Input.is_action_pressed("move_down"):
		scroll_direction = 1
	else:
		scroll_direction = 0
	if scroll_direction != 0:
		camera_2d.position.y += scroll_direction * SCROLL_SPEED * delta

	# Clamp the camera position
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("god_mode_debug"):
		god_mode_enabled = !god_mode_enabled
		#print("map god mode enabled")
		unlock_all_rooms(god_mode_enabled)
	
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLL_SPEED

	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)

func _on_new_game_started():
	# instantiate the map tut
	if Global.numResets != 0:
		var tut_scene = preload("res://Scenes/tutorial_interface.tscn")
		var tut_instance = tut_scene.instantiate()
		$MapBackground.add_child(tut_instance)

func unlock_all_rooms(enable: bool) -> void:
	for map_room: RoomBackend in rooms.get_children():
		map_room.available = enable
		if enable:
			map_room.animation_player.play("Highlight")
		else:
			var key = map_room.room.get_key()
			if GameState.room_states.has(key):
				var state = GameState.room_states[key]
				map_room.available = state["available"] and not state["selected"]
				if map_room.available:
					map_room.animation_player.play("Highlight")
				else:
					map_room.animation_player.stop()

func generate_new_map() -> void:
	floors_climbed = 0
	map_data = map_generator.generate_map()
	create_map()
	last_room = map_data[0][0]
	unlock_floor(0)

func load_map(map: Array[Array], floors_completed: int, last_room_climbed: Room) -> void:
	floors_climbed = floors_completed
	map_data = map
	last_room = last_room_climbed
	
	GameState.restore_room_states()
	create_map()
	
	for map_room: RoomBackend in rooms.get_children():
		var key = map_room.room.get_key()
		
		if key in GameState.room_states:
			if GameState.room_states[key]["selected"]:
				map_room.available = false
				map_room.animation_player.stop()
				map_room.show_selected()
			elif last_room and last_room.next_rooms.has(map_room.room):
				map_room.available = true
				GameState.room_states[key]["available"] = true
				map_room.animation_player.play("Highlight")
			else:
				map_room.available = false
				map_room.animation_player.stop()
	
	if GameState.player_died:
		var first_room_key = map_data[0][0].get_key()
		for map_room: RoomBackend in rooms.get_children():
			if map_room.room.get_key() == first_room_key:
				map_room.available = true
				map_room.animation_player.play("Highlight")
				break

	if floors_climbed > 0:
		unlock_next_rooms(last_room_climbed)
	else:
		return

func create_map() -> void:
	for current_floor: Array in map_data:
		for room: Room in current_floor:
			if room.next_rooms.size() > 0:
				_spawn_room(room)
	
	# Boss room has no next room but we need to spawn it
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	_spawn_room(map_data[MapGenerator.FLOORS-1][middle])

	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH - 1)
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2

func unlock_floor(which_floor: int = floors_climbed) -> void:
	# make sure rooms arent stuck being locked after clearing a lvl in god mode
	if god_mode_enabled:
		return

	for map_room: RoomBackend in rooms.get_children():
		var key = map_room.room.get_key()
		
		if not GameState.room_states.has(key):
			GameState.room_states[key] = {"selected": false, "available": false}

		if which_floor == 0:
			if GameState.player_died:
				if key == map_data[0][0].get_key():
					map_room.available = true
					map_room.animation_player.play("Highlight")
					GameState.room_states[key]["selected"] = false
					GameState.room_states[key]["available"] = true
					continue
					
			elif not Global.newGame and not GameState.player_died and Global.map_tutorial_has_run:
				return

		if GameState.room_states[key]["selected"]:
			map_room.available = false
			map_room.animation_player.stop()
			continue  
			
		if map_room.room.row == which_floor:
			map_room.available = true
			map_room.animation_player.play("Highlight")

func unlock_next_rooms(from_room: Room) -> void:
	# make sure rooms arent stuck being locked after clearing a lvl in god mode
	if god_mode_enabled:
		return

	for map_room: RoomBackend in rooms.get_children():
		if last_room.next_rooms.has(map_room.room) || from_room.next_rooms.has(map_room.room):
			map_room.available = true
			map_room.animation_player.play("Highlight")
			#print("new room unlocked!", map_room.room)
		else:
			map_room.available = false

func show_map() -> void:
	show()
	camera_2d.enabled = true


func hide_map() -> void:
	hide()
	camera_2d.enabled = false


func _spawn_room(room: Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as RoomBackend
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.map_data = map_data
	new_map_room.floors_climbed = floors_climbed
	new_map_room.clicked.connect(_on_map_room_clicked)
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)
	
	if room.selected and room.row < floors_climbed:
		new_map_room.show_selected()
		
func _connect_lines(room: Room) -> void:
	if room.next_rooms.is_empty():
		return
		
	for next: Room in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(room.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)


func _on_map_room_clicked(room: Room) -> void:
	for map_room: RoomBackend in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false

	var key = room.get_key()
	if key in GameState.room_states:
		GameState.room_states[key]["selected"] = true
		
	# campfire room stuff maybe delete
	#if room.type == Room.Type.CAMPFIRE or room.type == Room.Type.SHOP:
		#campfire_popup.show_popup()
		#print("campfire room clicked")
		
	unlock_next_rooms(room)

func _on_map_room_selected(room: Room) -> void:
	last_room = room
	floors_climbed += 1
	_on_map_room_clicked(room)
	


func _on_campfire_selected() -> void:
	#print("campfire popup triggered from global signal")
	var campfire_popup_scene = preload("res://Scenes/CampfireRoom.tscn")
	var popup_instance = campfire_popup_scene.instantiate()
	popup_instance.connect("heal_accepted", Callable(self, "_on_heal_accepted"))
	popup_instance.show_popup()

func _on_heal_accepted() -> void:
	#print("updating player health.")
	Global.player_health = Global.player_stats.base_max_health + Global.player_stats.additional_max_health_modifier
	#print("player health is now: ", Global.player_health)
