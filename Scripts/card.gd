extends TextureButton
class_name Card

var tween_hover: Tween
signal reward_selected(reward_type: int)

@export var reward_type: int = 0

func _ready():
	# Allow the card to react to mouse events
	self.focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Ensure the pressed() signal is connected
	if not is_connected("pressed", Callable(self, "_on_card_pressed")):
		connect("pressed", Callable(self, "_on_card_pressed"))
		print("Connected pressed signal to:", self.name)

	# Ensure signals are connected
	if not is_connected("mouse_entered", Callable(self, "_on_mouse_entered")):
		connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		
	if not is_connected("mouse_exited", Callable(self, "_on_mouse_exited")):
		connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_card_pressed() -> void:
	print("Card clicked, emitting reward:", reward_type)
	emit_signal("reward_selected", reward_type)

func set_card_texture(texture: Texture2D) -> void:
	self.texture_normal = texture  

func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)

func _on_mouse_exited() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_hover.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
