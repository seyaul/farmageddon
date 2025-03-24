extends HBoxContainer

@onready var heart_containers = $".".get_children()

const FULL_HEART = preload("res://Sprites/heart_textures/fullHeart.png")
const HALF_HEART = preload("res://Sprites/heart_textures/halfHeart.png")
const EMPTY_HEART = preload("res://Sprites/heart_textures/emptyHeart.png")

var heart_textures = [FULL_HEART, HALF_HEART, EMPTY_HEART]

var curr_health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_health = Global.playerHealth
	update_hearts(curr_health)
	await get_tree().process_frame
	Global.playerHealthNode.damage_taken.connect(handleSignal)
	Global.playerHealthNode.healed.connect(handleSignal)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handleSignal():
	curr_health = Global.playerHealthNode.current_health
	update_hearts(curr_health)
	
func update_hearts(current_hp):
	for i in range(heart_containers.size()):
		var heart = heart_containers[i]
		var heart_index = i * 2  # Each heart represents 2 HP
		if current_hp >= heart_index + 2:
			heart.texture = heart_textures[0]  # Full heart
		elif current_hp == heart_index + 1:
			heart.texture = heart_textures[1]  # Half heart
		else:
			heart.texture = heart_textures[2]  # Empty heart
	#print("damage taken in heart_container.gd")
