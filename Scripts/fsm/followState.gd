extends State

@export_enum("Cooldown", "Duration")
var attack_style: String

signal play_walk_animation
signal no_longer_slowed

@export var follow_target: Node2D
@export var speed: float = 25
@export var look_at_player: bool
@export var max_deviation_distance: float
# TODO: Refactor this
@export var action: String

var navigation: NavigationAgent2D
var enemy: CharacterBody2D
var targeter: Node
# TODO: Move to a global state
@export var start_with_attacks: bool
@export var distance_til_attack: float = 150
@export var num_attacks: int = 0
@export var attack_cooldown: int = 1

@export var time_following: int
var attacks: int
# TODO: Replace with timer?
var time: int
var slowdown_timer: Timer
var slowed_down: bool
var slowed_down_modifier: float

func Enter():
	if attack_style == "Duration":
		time = 0
	attacks = num_attacks if start_with_attacks else 0
	if targeter && not look_at_player:
		targeter.disabled = true
	emit_signal("play_walk_animation")

# TODO: Figure out how to elegatly manage both shooting and following states simulateously without messing with each other.
func Update(delta: float):
	if attack_style == "Duration":
		time += 1
	makepath()
	
	var dir = (navigation.get_next_path_position() - enemy.global_position).normalized()
	var distance_to_target = enemy.global_position.distance_to(navigation.target_position)
	
	if distance_to_target >= max_deviation_distance:
		if slowed_down:
			enemy.velocity = dir * speed * delta * slowed_down_modifier
		else:
			enemy.velocity = dir * speed * delta
		
	enemy.move_and_slide()
	if attack_style == "Cooldown" and distance_to_target <= distance_til_attack and attacks > 0:
		emit_signal("state_transition", self, action)
		attacks -= 1
	elif attack_style == "Duration" and time >= time_following:
		emit_signal("state_transition", self, action)
		
func makepath() -> void:
	if(navigation and follow_target != null):
		navigation.target_position = follow_target.global_position
	
func Exit():
	if targeter:
		targeter.disabled = false
	

func _physics_process(delta: float) -> void:
	if attack_style == "Cooldown":
		time += 1
		if time % attack_cooldown == 0 and attacks < num_attacks:
			attacks += num_attacks
			
func _ready() -> void:
	enemy = get_parent().get_parent()
	navigation = enemy.get_node("NavigationAgent2D")
	targeter = enemy.get_node("Targeter")
	attacks = num_attacks
	slowdown_timer = Timer.new()
	slowdown_timer.timeout.connect(stop_slow_down)
	add_child(slowdown_timer)

func slow_down(modifier: float, seconds: float):
	slowed_down = true
	slowed_down_modifier = modifier
	if slowdown_timer.is_stopped():
		slowdown_timer.start(seconds)
	else:
		slowdown_timer.stop()
		slowdown_timer.start(seconds)

func stop_slow_down():
	slowed_down = false
	emit_signal("no_longer_slowed")