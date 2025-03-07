extends TextureProgressBar

@export var health_node: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_node.damage_taken.connect(handleSignal)
	health_node.healed.connect(handleSignal)
	health_node.ready.connect(handleSignal)

func setHealthBar() -> void:
	value = 50
	#value = health_node.current_health
	
func handleSignal() -> void: 
	setHealthBar()
