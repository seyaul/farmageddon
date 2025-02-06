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
	
	if time >= time_shooting:
		emit_signal("state_transition", self, "Neutral")
	

func Exit():
	time = 0

func _ready() -> void:
	snake = get_parent().get_parent()
	guns = snake.get_node("Snake_Guns")
	
# TODO: Maybe add parameter values for this?
func shoot_guns(delta: float) -> void:
	if side_shooting == "Front":
		var segment = snake.segments[0]
		segment.lgun.fire(delta)
		segment.rgun.fire(delta)
	for i in range(snake.num_segments):
		if i % guns.segments_with_gun == 0:
			var segment = snake.segments[i]
			if (time % 10 == 0 and i % 2 == 0) or (time % 5 == 0 and i % 2 != 0):
				if side_shooting == "Left":
					segment.lgun.fire(delta)
				elif  side_shooting == "Right":
					segment.rgun.fire(delta)
					
