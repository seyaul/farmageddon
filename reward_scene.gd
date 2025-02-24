extends Control

@onready var card_container = $CardContainer
const CARD_SCENE = preload("res://Scenes/Card.tscn")
var cards = []

const CARD_TYPES = {
	0: preload("res://Sprites/healing (1).png"), 
	1: preload("res://Sprites/gold (1).png"),  
	2: preload("res://Sprites/xp (1).png")       
}

func _ready():
	# Create and configure each card dynamically
	for i in range(3):  
		var card = CARD_SCENE.instantiate() as Card
		card.set_card_texture(CARD_TYPES[i])
		card.mouse_filter = Control.MOUSE_FILTER_STOP
		
		# Connect signals to ensure hover works
		if not card.is_connected("mouse_entered", Callable(card, "_on_mouse_entered")):
			card.connect("mouse_entered", Callable(card, "_on_mouse_entered"))
		if not card.is_connected("mouse_exited", Callable(card, "_on_mouse_exited")):
			card.connect("mouse_exited", Callable(card, "_on_mouse_exited"))
		
		# Store card and manually set position
		cards.append(card)
		card_container.add_child(card)
		card.position = Vector2(-600, card_container.position.y)

	# Animate cards sliding into place
	slide_in_cards()

func slide_in_cards():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	for i in range(cards.size()):
		var card = cards[i]
		var target_x = card_container.position.x + (i * card_container.get("theme_override_constants/separation"))
		tween.tween_property(card, "position:x", target_x, 0.5).set_delay(i * 0.2)
