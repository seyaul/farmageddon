class_name RoomBackend
extends Area2D

signal clicked(room: Room)
signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("res://Sprites/chicken_high_res.png"), Vector2(0.1,0.1)],
	Room.Type.ELITE: [preload("res://Sprites/bull icon.png"), Vector2(0.15, 0.15)],
	Room.Type.TREASURE: [preload("res://Sprites/treasure.PNG"), Vector2(0.3, 0.3)],
	Room.Type.CAMPFIRE: [preload("res://Sprites/campfire-pixilart (2) (1).png"), Vector2(0.3, 0.3)],
	Room.Type.SHOP: [preload("res://Sprites/campfire-pixilart (2) (1).png"), Vector2(0.3, 0.3)],
	Room.Type.BOSS: [preload("res://Sprites/boss.PNG"), Vector2(0.2, 0.2)]
}

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var texture_button: TextureButton = $Visuals/TextureButton
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var room: Room : set = set_room
var map_data: Array
var floors_climbed: int

func set_available(new_value: bool) -> void:
	available = new_value
	texture_button.disabled = not new_value

	if available:
		animation_player.play("Highlight")
	else: 
		animation_player.stop()

func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]
	
	if room.selected:
		available = false
		show_selected()
	else:
		available = false

func show_selected() -> void:
	line_2d.modulate = Color.WHITE
	animation_player.stop()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return

	room.selected = true
	clicked.emit(room)
	print("clicked")
	animation_player.play("Select")

func _on_texture_button_pressed() -> void:
	if not available or Global.map_tutorial:
		return

	room.selected = true
	available = false  
  
	clicked.emit(room)
	print("clicked", room.get_key())
	

	var key = room.get_key()

	
	if not GameState.room_states.has(key):
		GameState.room_states[key] = {"selected": false, "available": true}

	GameState.room_states[key]["selected"] = true
	GameState.room_states[key]["available"] = false  
	animation_player.stop()
	texture_button.disabled = true 


	animation_player.play("Select")
	selected.emit(room) #kinda a safeguard
	
	if room.type == Room.Type.CAMPFIRE or room.type == Room.Type.SHOP:
		Global.emit_signal("campfire_selected")
		print("campfire selected")
	elif room.type == Room.Type.TREASURE:
		GameState.save_map_state(map_data, floors_climbed, room)
		get_tree().change_scene_to_file("res://Scenes/reward_scene.tscn")
		if Global.newGame:
			Global.emit_signal("newGameStarted")
		else:
			Global.emit_signal("gameStarted")
	elif room.type == Room.Type.ELITE:
		# Elite room tracking (temporary measure, any elite room multiplies enemy damage by 2.)
		Global.elite_room = 2
		GameState.save_map_state(map_data, floors_climbed, room)
		get_tree().change_scene_to_file("res://Scenes/testArea.tscn")
		# logging if the map has been generated because it is a new game/existing game
		if Global.newGame:
			Global.emit_signal("newGameStarted")
		else: 
			Global.emit_signal("gameStarted")
	elif room.type ==  Room.Type.BOSS:
		print("Boss room selected (roombackend)")
		Global.elite_room = 1
		GameState.save_map_state(map_data, floors_climbed, room)
		Global.emit_signal("bossLevelStarted")
		get_tree().change_scene_to_file("res://Scenes/old_major.tscn")
	else:
		Global.elite_room = 1
		GameState.save_map_state(map_data, floors_climbed, room)
		get_tree().change_scene_to_file("res://Scenes/testArea.tscn")
		# logging if the map has been generated because it is a new game/existing game
		if Global.newGame:
			Global.emit_signal("newGameStarted")
		else: 
			Global.emit_signal("gameStarted")
