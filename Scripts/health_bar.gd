extends ProgressBar


func _ready() -> void:
	self.max_value = $"../../../Player/Health".max_health
	$"../../../Player/Health".damage_taken.connect(handleSignal)
	$"../../../Player/Health".healed.connect(handleSignal)
	setHealthBar()
	#print(self.position)
	
func _process(delta: float) -> void:
	pass

func setHealthBar():
	self.value = $"../../../Player/Health".current_health
	
func handleSignal() -> void: 
	setHealthBar()
