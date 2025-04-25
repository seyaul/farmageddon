extends RichTextLabel

@export var typing_speed: float = 0.01 # Seconds per character
@export var blinking_speed: float = 0.5 # Seconds for cursor blink
@export var start_index: int = 0 # Initial visible character index (should be 0 for start)
var ending_index: int = 0 # Number of characters currently visible
var cut_off_end: int = 3 # Not used in this snippet, but kept for reference

var time_typed: float = 0.0
var time_blink: float = 0.0
var show_cursor: bool = true
var reached_end: bool = false

var original_text: String 

func _ready() -> void:
	ending_index = start_index
	text = "" # Start with an empty label

func _process(delta: float) -> void:
	if not reached_end:
		time_typed += delta
		if time_typed >= typing_speed:
			time_typed = 0
			ending_index += 1
			if ending_index >= original_text.length():
				reached_end = true
		_update_label()
	else:
		time_blink += delta
		if time_blink >= blinking_speed:
			time_blink = 0
			show_cursor = not show_cursor
		_update_label()

func _update_label():
	var display_text = original_text.substr(0, ending_index)
	if reached_end and show_cursor:
		display_text += "_" 
	text = display_text

func show_line(line: String):
	original_text = line
	ending_index = 0
	reached_end = false
	time_typed = 0.0
	show_cursor = true
	text = ""

func is_typing() -> bool:
	return not reached_end

func finish_typing():
	ending_index = original_text.length()
	reached_end = true
	_update_label()
