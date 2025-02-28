extends Node2D

var tut_node : Control 
var times_clicked : int
var mouse_node : Node2D
var test_bool
var ct_emitted: bool = false
var crosshair_timer : Timer
var crosshair_tip_shown : bool = false
signal crosshair_tip_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tut_node = $"../UserInterfaceLayer/TutorialInterface"
	tut_node.mouse_first_clicked.connect(show_tip)
	$CrosshairsSprite/Node2D/Crosshairinstr.visible = false
	crosshair_timer = $CrosshairsSprite/Node2D/Crosshairinstr/Timer
	crosshair_timer.timeout.connect(_on_timer_timeout)
	mouse_node = tut_node.get_node("MouseAndCrosshair")
	print(mouse_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_tip(mouse_tip_shown: bool):
	if times_clicked > 8:
		hide_crosshair_instr()
	elif mouse_tip_shown:
		if !crosshair_tip_shown:
			$CrosshairsSprite/Node2D/Crosshairinstr.visible = true
			crosshair_tip_shown = true
			times_clicked += 1
			if crosshair_timer.is_stopped():
				print("haiiiii")
				crosshair_timer.start()

	
func hide_crosshair_instr():
	$CrosshairsSprite/Node2D/Crosshairinstr.visible = false
	if !ct_emitted:
		crosshair_tip_complete.emit()
		ct_emitted = true
		
func _on_timer_timeout():
	hide_crosshair_instr()
