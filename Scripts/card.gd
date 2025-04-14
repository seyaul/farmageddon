extends TextureButton
class_name Card

# basic bitch variables 
@export var card_name: String
@export var description: String
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
signal reward_selected(reward_type: int)


@export var reward_type: int = 0

func _ready():
	# Allow the card to react to mouse events
	self.focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	self.texture_normal = icon
	self.tooltip_text = card_name + "\n" + description
	self.scale = Vector2(2.0, 2.0)
	
	# Ensure signals are connected
	if not is_connected("pressed", Callable(self, "_on_card_pressed")):
		connect("pressed", Callable(self, "_on_card_pressed"))
		print("Connected pressed signal to:", self.name)

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

func _on_card_pressed() -> void:
	#apply_card_effect(effect_data)
	emit_signal("reward_selected", self)

func set_card_texture(texture: Texture2D) -> void:
	self.texture_normal = texture  

func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(2.8, 2.8), 0.5)

func _on_mouse_exited() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_hover.tween_property(self, "scale", Vector2(2.0, 2.0), 0.3)
