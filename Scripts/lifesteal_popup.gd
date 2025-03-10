extends Control

@onready var label = $Label

# called when added to the scene
func _ready():
	size = Vector2(100, 50)
	self.visible = false

func show_popup():
	self.visible = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -50), 1.5).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0, 1.5)
	tween.tween_callback(queue_free)
