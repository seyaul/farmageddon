extends Control

@onready var card_container = $CardContainer
const CARD_SCENE = preload("res://Scenes/Card.tscn")
var cards = []
var selected_cards = []

const CARD_TYPES = {
	0: preload("res://Sprites/healing (1).png"), 
	1: preload("res://Sprites/gold (1).png"),  
	2: preload("res://Sprites/xp (1).png")       
}

func _ready():
	selected_cards = Global.get_random_rewards()
	# make sure previous cards are removed before generating new ones
	for child in card_container.get_children():
		child.queue_free()
	await get_tree().process_frame  

	generate_cards()
	slide_in_cards()

func generate_cards():
	for i in range(3):  
		var card = CARD_SCENE.instantiate() as Card
		var selected_data = selected_cards[i]

		card.card_name = selected_data["card_name"]
		card.description = selected_data["description"]
		card.icon = selected_data["icon"]
		card.rarity = selected_data["rarity"]
		card.can_repeat = selected_data["can_repeat"]
		card.weight = selected_data["weight"]
		card.modifies_player_stats = selected_data["modifies_player_stats"]
		card.modifies_gun_stats = selected_data["modifies_gun_stats"]
		
		if "effect_data" in selected_data:
			card.set_effect_data(selected_data["effect_data"])  
		else:
			card.set_effect_data({}) 

		if not card.is_connected("reward_selected", Callable(self, "_on_reward_selected")):
			card.connect("reward_selected", Callable(self, "_on_reward_selected"))

		card.position = Vector2(-1000, 242)
		card_container.remove_child(card)  
		add_child(card)  
		cards.append(card)

func slide_in_cards():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var final_x_positions = [120, 460, 800]  

	for i in range(cards.size()):
		var card = cards[i]
		var target_x = final_x_positions[i]  
		tween.tween_property(card, "position:x", target_x, 0.5).set_delay(i * 0.2)
		card_container.add_child(card)


func apply_card_effect(effect_data: Dictionary):
	if effect_data.keys().size() > 0:
		for key in effect_data.keys():
			if key in Global.player_stats:
				var old_value = Global.player_stats.get(key)
				var new_value = old_value + effect_data[key]
				Global.player_stats.set(key, new_value)
				print(key, " changed from ", old_value, " to ", new_value)
			elif key in Global.all_gun_stats:
				var old_value = Global.all_gun_stats.get(key)
				var new_value = old_value * effect_data[key]  
				Global.all_gun_stats.set(key, new_value)
				print(key, " changed from ", old_value, " to ", new_value)

func _on_reward_selected(card: Card) -> void:
	apply_card_effect(card.effect_data)
	Global.adjust_weights_after_selection(card.card_name)
	if card.card_name not in Global.chosen_buffs:
		Global.chosen_buffs.append(card.card_name)
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
