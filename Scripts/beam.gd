extends Line2D


@export var beam_damage: float = 0

var character: Node2D
var proc_area: Area2D
var targets = []

func _ready() -> void:
	character = get_parent()
	proc_area = get_node("ProcArea")
	proc_area.body_entered.connect(_on_body_entered)
	proc_area.body_exited.connect(_on_body_exited)
	
func _physics_process(delta):
	draw_arcs()

func _on_body_entered(body) -> void:
	var health = body.get_node("Health")
	if is_instance_valid(health):
		targets.append(body)
	
func _on_body_exited(body) -> void:
	targets.erase(body)

func draw_arcs() -> void:
	if targets.size() > 0:
		clear_points()
		add_point(to_local(character.global_position))
		for target in targets:
			add_point(to_local(target.global_position))
	else:
		clear_points()

func apply_damage() -> void:
	for target in targets:
		var health = target.get_node("Health")
		health.take_damage(beam_damage)
