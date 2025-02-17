extends Control

var curr_wave : int = 1
var max_waves : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# position is currently not relative to the player, I can fix but too sleepy rn
	# to figure out
	max_waves = $"../../WaveManager".num_waves
	$WaveNotificationText.text = "Wave " + str(curr_wave) + "/" + str(max_waves)
	$"../../WaveManager".wave_changed.connect(Callable(_on_wave_changed))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$WaveNotificationText.visible = false

func _on_wave_changed():
	curr_wave += 1
	$WaveNotificationText.text = "Wave " + str(curr_wave) + "/" + str(max_waves)
	$WaveNotificationText.visible = true
	$Timer.start
