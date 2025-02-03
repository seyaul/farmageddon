extends Node

var player: Node2D
var oscillationSpeed : float = 1
var time : float = 2
var base_pos
var oscillationMagnitude : float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../")
	self.position = Vector2(0, player.position.y + 100)
	base_pos = self.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if player: 
		#time += delta * oscillationSpeed
		#var newPos = Vector2(0, base_pos.x + abs(sin(time)) * oscillationMagnitude)
		#self.position = newPos
	pass
		
