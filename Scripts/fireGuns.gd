extends State

@export_enum("Front", "Left", "Right")
var side_shooting: String
@export var time_shooting: int

var snake: Snake
var guns: Node
var time: int

func Enter():
	pass
	
func Update(delta: float):
	time += 1
	
	if guns.guns_connected:
		shoot_guns(delta)
	print(time)
	if time >= time_shooting:
		emit_signal("state_transition", self, "Neutral")

func Exit():
	time = 0
	for i in range(1, snake.num_segments, guns.segments_with_gun):
		var segment = snake.segments[i]
		segment.emit_signal("shoot", 0, "end", 0)
		segment.emit_signal("shoot", 1, "end", 0)

func _ready() -> void:
	snake = get_parent().get_parent()
	guns = snake.get_node("Snake_Guns")
	
# TODO: Maybe add parameter values for this?
func shoot_guns(delta: float) -> void:
	if side_shooting == "Front":
		var segment = snake.segments[0]
		segment.emit_signal("shoot", 0, "hold", delta)
		segment.emit_signal("shoot", 1, "hold", delta)
	var parity: bool = true
	for i in range(1, snake.num_segments, guns.segments_with_gun):
		if parity:
			var segment = snake.segments[i]
			if side_shooting == "Left":
				segment.emit_signal("shoot", 0, "hold", delta)
			elif  side_shooting == "Right":
				segment.emit_signal("shoot", 1, "hold", delta)
		parity = not parity
	
