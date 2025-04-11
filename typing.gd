extends RichTextLabel

# Variables for typing effect and blinking cursor
@export var typing_speed: int = 1 # Seconds per character
@export var blinking_speed: int = 1
@export var start_index: int = 15 # Initial visible characters
var ending_index: int
@export var cut_off_end: int = 10
var time: int = 0
var show_cursor: bool = true # Toggles the visibility of the blinking "_"
var reached_end: bool = false

func _ready() -> void:
	ending_index = text.length() - (cut_off_end + start_index + 1)

func _process(delta: float) -> void:
	# Increment time
	time += 1
	if not reached_end:
		if visible_characters > ending_index:
			reached_end = true
		elif time % typing_speed == 0:
			time = 0
			visible_characters += 1
		return

	if reached_end and time % blinking_speed == 0:
		show_cursor = not show_cursor

	# Build the text with the blinking cursor
	var base_text = text.substr(start_index, ending_index) # Get visible portion of the text
	if show_cursor:
		base_text += "\uFF3F" # Show the blinking cursor

	# Update the bbcode_text with black background
	text = "[bgcolor=black]" + base_text + "[/bgcolor]"
