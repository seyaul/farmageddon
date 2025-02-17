extends Control

var isPaused : bool = false:
	set = set_paused

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.isPaused = !isPaused

func set_paused(value:bool) -> void:
	isPaused = value
	get_tree().paused = isPaused
	visible = isPaused
	
func _on_resume_pressed():
	isPaused = false


func _on_start_new_run_pressed() -> void:
	self.isPaused = !isPaused
	GameState.player_died = true
	get_tree().change_scene_to_file("res://Scenes/Map.tscn")
	Global.enemyCount = 0
	Global.numRuns = 0
	Global.newGame = true
