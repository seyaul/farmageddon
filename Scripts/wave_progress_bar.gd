extends ProgressBar

var total_enemies: int = 0  # Total enemies in the current wave
var enemies_defeated: int = 0  # How many enemies have been defeated
var wave_manager_node: Node
var tut_scene
func _ready():
	value = 0  # Start with an empty bar
	self.visible = false
	wave_manager_node = get_parent().get_parent().get_parent().get_node("WaveManager")
	tut_scene = get_parent().get_parent().get_node("TutorialInterface")
	tut_scene.tutorial_finished2.connect(handle_signal)
	if !Global.tutorial:
		self.visible = true
		await get_tree().process_frame
		total_enemies = wave_manager_node.tot_enemy_count

# Change this to be a signal eventually
func _process(delta : float):
	if !Global.tutorial:
		enemies_defeated = Global.num_enemies_defeated
		update_progress()



## Call this function when a new wave starts
#func set_wave(total: int):
	#total_enemies = total
	#enemies_defeated = 0
	#max_value = total_enemies  # Ensure bar fills up correctly
	#value = 0  # Reset progress

# Call this function whenever an enemy is defeated
func update_progress():
	value = float(enemies_defeated) / float(total_enemies) * 100  # Update the progress bar
	if enemies_defeated >= total_enemies and !Global.tutorial:
		print("Wave Complete!")

func handle_signal():
	self.visible = true
	total_enemies = wave_manager_node.tot_enemy_count
