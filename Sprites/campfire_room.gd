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
	#modulate.a = 1.0
	#var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	#tween.tween_property(self, "position:y", position.y - 20, duration * 0.5)
	#await get_tree().create_timer(duration).timeout
#
	#tween.tween_property(self, "modulate:a", 0.0, duration * 0.5)
	#tween.tween_callback(queue_free) 
	
