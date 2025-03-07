extends State

@export var speed: float = 25
var enemy: CharacterBody2D

func Enter():
	pass

# TODO: Figure out how to elegatly manage both shooting and following states simulateously without messing with each other.
func Update(delta: float):
	pass

func Exit():
	pass

func _ready() -> void:
	enemy = get_parent().get_parent()


func _physics_process(delta: float) -> void:
	pass
