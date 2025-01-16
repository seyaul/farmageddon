extends State

@export var follow_target: Node2D
@export var speed: float = 100
@export var bias: float = 0.5
# TODO: Refactor this
@export var action1: String
@export var action2: String

var navigation: NavigationAgent2D
var enemy: CharacterBody2D
var targeter: Node
# TODO: Move to a global state
@export var distance_til_attack: float = 150
@export var num_attacks: int = 0
@export var attack_cooldown: int = 1
var attacks: int
# TODO: Replace with timer?
var time: int



func Enter():
	enemy = get_parent().get_parent()
	navigation = enemy.get_node("NavigationAgent2D")
	targeter = enemy.get_node("Targeter")
	if targeter:
		targeter.disabled = true
	
func Update(delta: float):
	makepath()
	
	# NOTE: Manually telling where the parent to look at. Might be subject to change in the future.
	enemy.look_at(navigation.get_next_path_position())
	var dir = (navigation.get_next_path_position() - enemy.global_position).normalized()
	enemy.velocity = dir * speed * delta
	enemy.move_and_slide()
	if enemy.global_position.distance_to(navigation.target_position) <= distance_til_attack and attacks > 0:
		if randf() < bias:
			emit_signal("state_transition", self, action1)
		else:
			emit_signal("state_transition", self, action2)
		attacks -= 1
func makepath() -> void:
	navigation.target_position = follow_target.global_position

func Exit():
	if targeter:
		targeter.disabled = false

func _physics_process(delta: float) -> void:
	time += 1
	if time % attack_cooldown == 0 and attacks < num_attacks:
		attacks += num_attacks
		
func _ready() -> void:
	attacks = num_attacks
