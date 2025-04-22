extends Control

var curr_wave : int = 1
var max_waves : int
var tut_node : Control
var warned : bool = false
var wave_manager_node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_manager_node = $"../../WaveManager"
	$waveCompleteNotifier.visible = false 
	$EliteDifficultyWarning.visible = false
	wave_manager_node.setup_complete_wn.connect(handle_setup_complete)
	wave_manager_node.level_complete.connect(handle_level_complete)
	if Global.tutorial:
		tut_node = $"../TutorialInterface"
		tut_node.start_wave.connect(handle_start_wave)
		$WaveNotificationText.visible = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
		
func _on_timer_timeout() -> void:
	$WaveNotificationText.visible = false
	if Global.elite_room == 2 and !warned:
		warned = true
		
		await get_tree().create_timer(1.5).timeout
		$EliteDifficultyWarning.visible = true
		await get_tree().create_timer(2.5).timeout
		$EliteDifficultyWarning.visible = false

func _on_wave_changed():
	curr_wave += 1
	$WaveNotificationText.text = "Wave " + str(curr_wave) + "/" + str(max_waves)
	$WaveNotificationText.visible = true
	$Timer.start(3) 

func handle_start_wave():
	max_waves = $"../../WaveManager".num_waves
	$WaveNotificationText.text = "Wave " + str(curr_wave) + "/" + str(max_waves)
	$"../../WaveManager".wave_changed.connect(Callable(_on_wave_changed))
	$WaveNotificationText.visible = true
	$Timer.start()
	
func handle_setup_complete():
	if !Global.tutorial:
		max_waves = $"../../WaveManager".num_waves
		$WaveNotificationText.text = "Wave " + str(curr_wave) + "/" + str(max_waves)
		$"../../WaveManager".wave_changed.connect(Callable(_on_wave_changed))

func handle_level_complete():
	$waveCompleteNotifier.visible = true
