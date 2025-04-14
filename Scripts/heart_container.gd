extends HBoxContainer

const FULL_HEART = preload("res://Sprites/heart_textures/fullHeart.png")
const HALF_HEART = preload("res://Sprites/heart_textures/halfHeart.png")
const EMPTY_HEART = preload("res://Sprites/heart_textures/emptyHeart.png")

var heart_textures = [FULL_HEART, HALF_HEART, EMPTY_HEART]

@onready var HeartScene = preload("res://Scenes/heart.tscn")  # This should be a TextureRect or whatever you use

var curr_health: int

func _ready() -> void:
	curr_health = Global.playerHealth 
	update_hearts(curr_health)

	await get_tree().process_frame
	Global.playerHealthNode.damage_taken.connect(handleSignal)
	Global.playerHealthNode.healed.connect(handleSignal)


func handleSignal():
	curr_health = Global.playerHealth
	update_hearts(curr_health)

func update_hearts(current_hp):
	var max_hp = Global.playerHealthNode.player_max_health + Global.player_stats.additional_max_health_modifier
	print("max_hp ", max_hp)
	var heart_count = int(ceil(max_hp / 2.0))

	# Create hearts if needed
	while get_child_count() < heart_count:
		var heart = HeartScene.instantiate()
		add_child(heart)

	# Remove extra hearts if any
	while get_child_count() > heart_count:
		get_child(get_child_count() - 1).queue_free()

	# Update textures
	for i in range(heart_count):
		var heart = get_child(i)
		var heart_index = i * 2
		if current_hp >= heart_index + 2:
			heart.texture = heart_textures[0]  # Full
		elif current_hp == heart_index + 1:
			heart.texture = heart_textures[1]  # Half
		else:
			heart.texture = heart_textures[2]  # Empty
