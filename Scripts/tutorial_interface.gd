extends Control

var keyboard_tut_timer: SceneTreeTimer
var tutorial_segments = [["move_up", "move_left", "move_right", "move_down"],
						 ["dash"],
						 ["shockwave"],
						 ["shoot"],
						 ["switch_weapon"]]
var curr_tut_seg : int  = 0
var remaining_to_press = []
var mouse_tooltip_shown : bool = false
var crosshairs_node : Node2D

signal mouse_first_clicked
signal tutorial_finished
# TODO: figure out a better way to do this 
signal tutorial_finished2
signal weapon_switched
signal start_wave

# Called when the node enters the scene tree for the firdst time.
func _ready() -> void:
	crosshairs_node = $"../../Crosshairs"
	crosshairs_node.crosshair_tip_complete.connect(crosshair_handle)
	self.weapon_switched.connect(weapon_handle)
	hide_all()
	if Global.tutorial:
		start_step(curr_tut_seg)
		$KeyboardButtons/MovementInfo.visible = true
		$KeyboardButtons/Wasdinstr.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_step(step_idx : int):
	if step_idx < tutorial_segments.size():
		match tutorial_segments[step_idx][0]:
			"dash":
				$KeyboardButtons/Spacebar.visible = true
				$KeyboardButtons/Spaceinstr.visible = true
			"shockwave":
				$KeyboardButtons/Shiftinstr.visible = true
				$KeyboardButtons/Shift.visible = true
			"shoot":
				$MouseAndCrosshair.visible = true
				mouse_tooltip_shown = true
			"switch_weapon":
				$WeaponInstr.visible = true
		remaining_to_press = tutorial_segments[step_idx].duplicate()
		print(remaining_to_press, " remaining to press in tut.gd")
	else:
		#Global.tutorial = false
		#tutorial_finished.emit()
		#tutorial_finished2.emit()
		#start_wave.emit()
		pass
		
func hide_all():
	$MouseAndCrosshair.visible = false
	$WeaponInstr.visible = false
	$KeyboardButtons/MovementInfo.visible = false
	$KeyboardButtons/Spacebar.visible = false
	$KeyboardButtons/Shiftinstr.visible = false
	$KeyboardButtons/Shift.visible = false
	$KeyboardButtons/Spaceinstr.visible = false
	$KeyboardButtons/Wasdinstr.visible = false

func _input(event):
	if event is InputEvent and Global.tutorial:
		if event.is_action_pressed("shoot"):
			if !remaining_to_press.is_empty():
				if remaining_to_press[0] == "shoot":
					remaining_to_press.erase("shoot")
					hide_all()
					curr_tut_seg += 1
			emit_signal("mouse_first_clicked", mouse_tooltip_shown)
		elif event.is_action_pressed("skip_tutorial"):
			if Global.tutorial:
				Global.tutorial = false
				mouse_tooltip_shown = false
				hide_all()
				tutorial_segments = []
				tutorial_finished.emit()
				tutorial_finished2.emit()
				start_wave.emit()
		else:
			for button in remaining_to_press:
				if Input.is_action_just_pressed(button):
					remaining_to_press.erase(button)
					if remaining_to_press.is_empty():
						hide_all()
						if curr_tut_seg < tutorial_segments.size() - 2:
							print(curr_tut_seg, " ", tutorial_segments.size() - 2, " in tutint.gd")
							curr_tut_seg += 1
							start_step(curr_tut_seg)
						else:
							weapon_switched.emit()


# custom signal handling function that is need to just so that the screen isn't cluttered?
func crosshair_handle():
	if Global.tutorial:
		print("checking crosshair handle, ", curr_tut_seg)
		start_step(curr_tut_seg)

func weapon_handle():
	if Global.tutorial:
		Global.tutorial = false
		tutorial_finished.emit()
		tutorial_finished2.emit()
		start_wave.emit()

	
