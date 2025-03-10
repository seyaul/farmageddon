extends TextureProgressBar

@export var health_node: Node
var current_health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_value = health_node.max_health
	self.value = health_node.current_health
	health_node.damage_taken.connect(handleSignal)
	health_node.healed.connect(handleSignal)
	health_node.ready.connect(handleSignal)

func setHealthBar() -> void:
	value = health_node.current_health
	#value = health_node.current_health
	
func handleSignal() -> void: 
	setHealthBar()
