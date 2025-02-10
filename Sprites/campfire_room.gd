extends Control

signal heal_accepted  

@onready var text_box = $Panel/TextBox
@onready var yes_button = $Panel/YesButton
@onready var no_button = $Panel/NoButton

func _ready() -> void:
	hide()
	position = Vector2(get_viewport_rect().size.x / 2 - size.x / 2, get_viewport_rect().size.y - 100)  
	yes_button.connect("pressed", Callable(self, "_on_yes_button_pressed"))
	no_button.connect("pressed", Callable(self, "_on_no_button_pressed"))

func show_popup():
	show()

func _on_no_button_pressed():
	# implement gold/exp stuff here
	hide()  


func _on_yes_button_pressed() -> void:
	Global.player_health = Global.max_health 
	print("Player healed to full health:", Global.player_health)
	hide()  
	emit_signal("heal_accepted")  
