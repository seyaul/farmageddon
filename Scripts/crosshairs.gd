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
	if has_node("../UserInterfaceLayer/TutorialInterface"):
		tut_node = $"../UserInterfaceLayer/TutorialInterface"
		tut_node.mouse_first_clicked.connect(show_tip)
		mouse_node = tut_node.get_node("MouseAndCrosshair")
	$CrosshairsSprite/Node2D/Crosshairinstr.visible = false
	if has_node("CrosshairsSprite/Node2D/newWeaponNoti"):
		$CrosshairsSprite/Node2D/newWeaponNoti.visible = false
		if Global.numLevelsComplete == 1 or Global.numLevelsComplete == 2:
			handle_new_weapon_unlocked()
	#Global.newWeaponUnlocked.connect(handle_new_weapon_unlocked)
	crosshair_timer = $CrosshairsSprite/Node2D/Crosshairinstr/Timer
	crosshair_timer.timeout.connect(_on_timer_timeout)
	self.start_timer.connect(timer_handler)
	#print(mouse_node)


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
		#print(times_clicked)
	elif !mouse_tip_shown:
		hide_crosshair_instr()

	
func hide_crosshair_instr():
	$CrosshairsSprite/Node2D/Crosshairinstr.visible = false
	if !ct_emitted and crosshair_tip_shown:
		crosshair_tip_complete.emit()
		ct_emitted = true
		
func _on_timer_timeout():
	hide_crosshair_instr()

func timer_handler():
	crosshair_timer.start()

func handle_new_weapon_unlocked():
	#print("Is this thing one")
	$CrosshairsSprite/Node2D/newWeaponNoti.visible = true
	await get_tree().create_timer(5).timeout
	$CrosshairsSprite/Node2D/newWeaponNoti.visible = false
