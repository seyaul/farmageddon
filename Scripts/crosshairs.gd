extends Node2D

var tut_node : Control 
var times_clicked : int
var mouse_node : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tut_node = $"../UserInterfaceLayer/TutorialInterface"
	tut_node.mouse_first_clicked.connect(show_tip)
	$CrosshairsSprite/Node2D/Crosshairinstr.visible = false
	mouse_node = tut_node.get_node("MouseAndCrosshair")
	print(mouse_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_tip():
	if times_clicked > 10:
		$CrosshairsSprite/Node2D/Crosshairinstr.visible = false
	elif mouse_node.visible == true:
		$CrosshairsSprite/Node2D/Crosshairinstr.visible = true
	times_clicked += 1
	
