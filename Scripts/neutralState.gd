extends State

@export var neutral_until_condition: bool
@export var distance_til_attack: float
var enemy: CharacterBody2D
var navigation: NavigationAgent2D

func Enter():
	enemy = get_parent().get_parent()
	navigation = enemy.get_node("NavigationAgent2D")
	
func Update(_delta: float):
	if neutral_until_condition and \
	enemy.global_position.distance_to(navigation.target_position) <= distance_til_attack or \
	not neutral_until_condition:
		emit_signal("state_transition", self, "Shoot")
	
func Exit():
	pass
