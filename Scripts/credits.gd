extends Control

# Set the speed of the credits scroll (pixels per second)
var scroll_speed: float = 0.2
var scroll_accumulation: float = 0

# Called when the node enters the scene tree
func _ready():
	# Optional: start at the top
	$ScrollContainer.scroll_vertical = 0

func _process(delta):
	scroll_accumulation += scroll_speed
	if scroll_accumulation >= 1:
		scroll_accumulation = 0
		var v_scroll = $ScrollContainer.scroll_vertical
		$ScrollContainer.scroll_vertical = v_scroll + 1
