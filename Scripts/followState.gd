extends State

@export var follow_target: Node2D
@export var speed: float = 100

var navigation: NavigationAgent2D
var enemy: CharacterBody2D

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
	
func Update(_delta: float):
	makepath()
	
	# NOTE: Manually telling where the parent to look at. Might be subject to change in the future.
	enemy.look_at(navigation.get_next_path_position())
	var dir = Vector2(cos(enemy.global_rotation), sin(enemy.global_rotation)).normalized()
	enemy.velocity = dir * speed
	enemy.move_and_slide()
	print(enemy.global_position.distance_to(navigation.target_position) <= distance_til_attack, attacks > 0)
	if enemy.global_position.distance_to(navigation.target_position) <= distance_til_attack and attacks > 0:
		emit_signal("state_transition", self, "Lunge")
		attacks -= 1
	
func makepath() -> void:
	navigation.target_position = follow_target.global_position

func Exit():
	pass

func _physics_process(delta: float) -> void:
	time += 1
	if time % attack_cooldown == 0 and attacks < num_attacks:
		attacks += num_attacks
		
func _ready() -> void:
	attacks = num_attacks
