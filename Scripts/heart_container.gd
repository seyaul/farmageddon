extends HBoxContainer

@onready var heart_nodes = $".".get_children()

const FULL_HEART = preload("res://Sprites/heart_textures/fullHeart.png")
const HALF_HEART = preload("res://Sprites/heart_textures/halfHeart.png")
const EMPTY_HEART = preload("res://Sprites/heart_textures/emptyHeart.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_hearts(current_hp):
	for i in range(heart_nodes.size()):
		var heart_texture = EMPTY_HEART  # Default to empty

		if current_hp >= (i + 1) * 2:
			heart_texture = FULL_HEART
		elif current_hp == (i * 2) + 1:
			heart_texture = HALF_HEART
		heart_nodes[i].texture = heart_texture
