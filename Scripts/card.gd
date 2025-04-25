extends TextureButton
class_name Card

# basic bitch variables 
@export var card_name: String
@export var description: Texture2D
@export var icon: Texture2D
@export var rarity: String 
@export var can_repeat: bool
# this is here so we can make individual cards show up more than others,
# can be removed if needed though since weights are also assigned to rarities
@export var weight: float = 1.0

@export var modifies_player_stats: bool = false
@export var modifies_gun_stats: bool = false
@export var effect_data: Dictionary = {} 

var tween_hover: Tween
@onready var description_sprite := $Desc
signal reward_selected(reward_type: int)

@onready var front := $Front
@onready var back := $Back
@onready var animation_player := $AnimationPlayer
@onready var collision_shape := $HoverArea/CollisionShape2D
# @onready var button := $ButtonRoot/Card
@onready var hover_area := $HoverArea

@export var reward_type: int = 0

func _ready():
	# Allow the card to react to mouse events
	self.focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP

	front.texture = icon
	back.texture = preload("res://Sprites/new cards/card back with title and body.png")
	description_sprite.texture = description

	$Front.position = Vector2.ZERO
	$Back.position = Vector2.ZERO

	front.visible = true
	back.visible = false
	description_sprite.visible = false

	#self.tooltip_text = card_name + "\n" + description
	self.scale = Vector2(2.0, 2.0)

	# please work
	await get_tree().process_frame
	if front.texture:
		var size = front.texture.get_size()
		#print("sizes:", size.x, size.y)
		var shape = RectangleShape2D.new()
		shape.size = size
		collision_shape.shape = shape
		collision_shape.position = Vector2(0, 0)

	# Ensure signals are connected
	if not is_connected("pressed", Callable(self, "_on_card_pressed")):
		connect("pressed", Callable(self, "_on_card_pressed"))

	if not is_connected("mouse_entered", Callable(self, "_on_mouse_entered")):
		connect("mouse_entered", Callable(self, "_on_mouse_entered"))

	if not is_connected("mouse_exited", Callable(self, "_on_mouse_exited")):
		connect("mouse_exited", Callable(self, "_on_mouse_exited"))

# what da hell why is this function defined twice what im too scared to delete it tho
#func apply_card_effect(effect_data: Dictionary):
	#if effect_data.keys().size() > 0:
		#for key in effect_data.keys():
			#if key in Global.player_stats:
				#var old_value = Global.player_stats.get(key)
				#var new_value = old_value + effect_data[key]
				#Global.player_stats.set(key, new_value)
#
			#elif key in Global.all_gun_stats:
				#var old_value = Global.all_gun_stats.get(key)
				#var new_value = old_value * effect_data[key]  
				#Global.all_gun_stats.set(key, new_value)

func set_effect_data(data: Dictionary) -> void:
	effect_data = data.duplicate(true)  

func _on_hover_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_card_pressed()

func _on_card_pressed() -> void:
	emit_signal("reward_selected", self)

func set_card_texture(texture: Texture2D) -> void:
	self.texture_normal = texture  

#func show_description_sprite():
	#if description and not description_sprite:
		#description_sprite = Sprite2D.new()
		#description_sprite.texture = description
		#description_sprite.scale = Vector2(1, 1)  
		#add_child(description_sprite)
		#description_sprite.position = Vector2.ZERO  
		#description_sprite.z_index = 1  
#
#func hide_description_sprite():
	#if description_sprite:
		#description_sprite.queue_free()
		#description_sprite = null

func _on_mouse_entered() -> void:
	if animation_player.has_animation("flip_to_back"):
		animation_player.play("flip_to_back")

func _on_mouse_exited() -> void:
	if animation_player.has_animation("flip_to_front"):
		animation_player.play("flip_to_front")
