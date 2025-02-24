extends Control

var keyboard_tut_timer: SceneTreeTimer

signal mouse_first_clicked

# Called when the node enters the scene tree for the firdst time.
func _ready() -> void:
	$MouseAndCrosshair.visible = false
	$WeaponInstr.visible = false
	await get_tree().create_timer(5).timeout
	$KeyboardButtons.visible = false
	$MouseAndCrosshair.visible = true
	await get_tree().create_timer(5).timeout
	$MouseAndCrosshair.visible = false
	$WeaponInstr.visible = true
	await get_tree().create_timer(5).timeout
	$WeaponInstr.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		emit_signal("mouse_first_clicked")

	