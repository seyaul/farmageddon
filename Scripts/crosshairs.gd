extends Node2D

var tut_node : Control 
var times_clicked : int
var mouse_node : Node2D
var test_bool
var ct_emitted: bool = false
var crosshair_timer : Timer
var crosshair_tip_shown : bool = false
signal crosshair_tip_complete

signal start_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tut_node = $"../UserInterfaceLayer/TutorialInterface"
	tut_node.mouse_first_clicked.connect(show_tip)
	$CrosshairsSprite/Node2D/Crosshairinstr.visible = false
	crosshair_timer = $CrosshairsSprite/Node2D/Crosshairinstr/Timer
	crosshair_timer.timeout.connect(_on_timer_timeout)
	self.start_timer.connect(timer_handler)
	mouse_node = tut_node.get_node("MouseAndCrosshair")
	print(mouse_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_tip(mouse_tip_shown: bool):
	if times_clicked > 8:
		hide_crosshair_instr()
	elif mouse_tip_shown:
		if not crosshair_tip_shown:
			$CrosshairsSprite/Node2D/Crosshairinstr.visible = true
			crosshair_tip_shown = true
			if crosshair_timer.is_stopped():
				start_timer.emit()
				pass
		times_clicked += 1
		print(times_clicked)
	else:
		hide_crosshair_instr()

	
func hide_crosshair_instr():
	$CrosshairsSprite/Node2D/Crosshairinstr.visible = false
	if !ct_emitted:
		crosshair_tip_complete.emit()
		ct_emitted = true
		
func _on_timer_timeout():
	hide_crosshair_instr()

func timer_handler():
	crosshair_timer.start()
