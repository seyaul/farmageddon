extends TextureRect

# Optionally preload textures if you want self-contained hearts
const FULL_HEART = preload("res://Sprites/heart_textures/fullHeart.png")
const HALF_HEART = preload("res://Sprites/heart_textures/halfHeart.png")
const EMPTY_HEART = preload("res://Sprites/heart_textures/emptyHeart.png")

func set_heart_state(state: String):
	match state:
		"full":
			texture = FULL_HEART
		"half":
			texture = HALF_HEART
		"empty":
			texture = EMPTY_HEART
