extends Node2D

var player_instance
var health_node
@onready var you_win_label = $UserInterfaceLayaer/YouWinLabel
@onready var fade_rect = $UserInterfaceLayaer/blackBox
@export var target_node_1: Node
@export var target_node_2: Node
@export var target_node_3: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_instance = Global.playerInstance
	add_child(player_instance)
	target_node_1.target = player_instance
	target_node_2.follow_target = player_instance
	target_node_3.target = player_instance
	health_node = $Boss/Health
	print(health_node)
	health_node.you_win.connect(handle_you_win)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_you_win():
	print("Handled")
	you_win_label.visible = true
	var target_pos = Vector2(you_win_label.position.x, 122) # y=200 is just an example
	
	var tween = create_tween()
	tween.tween_property(you_win_label, "position", target_pos, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# 2. Fade to black, slightly delayed
	tween.tween_interval(0.5) # optional: wait a bit after text lands
	tween.tween_property(fade_rect, "modulate:a", 1.0, 3.0)
	
	# 3. After fade, go to win screen
	tween.tween_callback(Callable(self, "_go_to_win_screen"))
	
func _go_to_win_screen():
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
