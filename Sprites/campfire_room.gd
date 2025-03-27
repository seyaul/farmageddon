extends Control

@export var duration: float = 1.5  

func _ready() -> void:
	size = Vector2(300, 100)
	self.visible = false

func show_popup():
	self.visible = true

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.5).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)
