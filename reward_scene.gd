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
		card.reward_type = i  # Assign correct reward type

		# Ensure the signal is connected correctly
		if not card.is_connected("reward_selected", Callable(self, "_on_reward_selected")):
			card.connect("reward_selected", Callable(self, "_on_reward_selected"))
			print("Connected reward_selected signal for card", i)

		# Store and add card
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

func _on_reward_selected(reward_type: int) -> void:
	print("Reward selected:", reward_type)

	match reward_type:
		0:
			Global.playerHealth = min(Global.playerHealth + 10, Global.playerMaxHealth)
			print("Player health is now:", Global.playerHealth)
		1:
			Global.playerGold += 100  
			print("Player gold is now:", Global.playerGold)
		2:
			Global.playerExp += 50  
			print("Player EXP is now:", Global.playerExp)

	get_tree().change_scene_to_file("res://Scenes/Map.tscn")
