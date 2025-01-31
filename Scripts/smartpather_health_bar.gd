extends ProgressBar

var mobhealth : int
var health_node: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_tree()
	var health_node = $"../Health"
	print(health_node)
	mobhealth = health_node.max_health
	health_node.damage_taken.connect(handleSignal)
	health_node.healed.connect(handleSignal)
	setHealthBar()
	#print(self.position)
	
func _process(delta: float) -> void:
	pass

func setHealthBar():
	self.value = $"../Health".current_health
	
func handleSignal() -> void: 
	setHealthBar()
