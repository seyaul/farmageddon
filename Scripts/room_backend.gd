class_name RoomBackend
extends Area2D

signal clicked(room: Room)
signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("res://Sprites/skull_v1_1.png"), Vector2.ONE],
	Room.Type.ELITE: [preload("res://Sprites/skeleton_v1_1.png"), Vector2.ONE],
	Room.Type.TREASURE: [preload("res://Sprites/mini_chest_1.png"), Vector2.ONE],
	Room.Type.CAMPFIRE: [preload("res://Sprites/torch_4.png"), Vector2(0.6, 0.6)],
	Room.Type.SHOP: [preload("res://Sprites/coin_1.png"), Vector2(0.6, 0.6)],
	Room.Type.BOSS: [preload("res://Sprites/vampire_v1_1.png"), Vector2(1.25, 1.25)]
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
	elif not room.selected:
		animation_player.play("RESET")


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


# Called by the AnimationPlayer when the "Select" animation finishes
#func _on_map_room_selected() -> void:
	#selected.emit(room)
	#get_tree().change_scene_to_file("res://Scenes/testArea.tscn")
	#print("selected")
#
#
#func _on_selected(room: Room) -> void:
	#selected.emit(room)
	#get_tree().change_scene_to_file("res://Scenes/testArea.tscn")
	#print("selected")


func _on_texture_button_pressed() -> void:
	if not available:
		return
	
	room.selected = true
	available = false  
	animation_player.stop()
	show_selected()  
	clicked.emit(room)
	print("clicked")
	
	var key = room.get_key()
	if not GameState.room_states.has(key):
		GameState.room_states[key] = {"selected": false}
	GameState.room_states[key]["selected"] = true
	
	animation_player.play("Select")
	selected.emit(room) #kinda a safeguard
	
	GameState.save_map_state(map_data, floors_climbed, room)
	get_tree().change_scene_to_file("res://Scenes/testArea.tscn")
	print("selected")
