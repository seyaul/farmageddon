extends Control

@onready var player_label = $"../TextureRect/YourDialogue"
@onready var farmer_label = $"../messageBox/FarmerDialogue"
@onready var pb = $"../TextureRect"
@onready var fb = $"../messageBox"


var dialogue1 = [
	{"speaker": "player", "line": "(This is Old Man Jenkins. Maybe he'll know what's happening and how to find my dog.)"},
	{"speaker": "player", "line": "Hi Old Man Jenkins. How are you?"},
	{"speaker": "farmer", "line": "KILL DEM ANIMALS DANGNABBIT!!"},
	{"speaker": "player", "line": "Oh okay..."},
	{"speaker": "farmer", "line": "DEM GOSH DARN MUTATED ANIMALS INVADING MY DANGNAB FARM SONNY!"},
	{"speaker": "player", "line": "Oh fr that's crazy"},
	{"speaker": "farmer", "line": "I SAW ONE OF DEM MUTATED ANIMALS KIDNAPPING YOUR DOG!!"},
	{"speaker": "farmer", "line": "KILL DEM ALL AND YOUR DOG WILL TURN UP, THAT'S ON BESSIE!"},
	{"speaker": "player", "line": "Call me Stan"},
	{"speaker": "farmer", "line": "Stan?"},
	{"speaker": "player", "line": "Cause it's a plan."}
]
var current_index = 0

func _ready():
	#print("Farmer label node: ", farmer_label)
	show_next_line()



func show_next_line():
	if current_index >= dialogue1.size():
		fade_to_black()
		await get_tree().create_timer(1.5).timeout
		## Make it wait if the scene hasn't loaded yet
		get_tree().change_scene_to_file("res://Scenes/Map.tscn")
		return  # End of dialogue
	var entry = dialogue1[current_index]
	if entry.speaker == "player":
		pb.visible = true
		fb.visible = false
		player_label.show_line(entry.line)
	else:
		pb.visible = false
		fb.visible = true
		farmer_label.show_line(entry.line)
	current_index += 1

func _input(event):
	if event.is_action_pressed("ui_accept"):
		# Determine which label is visible
		if pb.visible and player_label.is_typing():
			player_label.finish_typing()
		elif fb.visible and farmer_label.is_typing():
			farmer_label.finish_typing()
		else:
			show_next_line()

func fade_to_black():
	$"../ColorRect".visible = true  
	var tween = create_tween() 
	tween.tween_property($"../ColorRect", "modulate:a", 1.0, 1.0)
