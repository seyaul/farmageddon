extends Area2D

@export var damage: float
@export var shockwave_duration: float
@export var shockwave_radius: float
@export var shockwave_strength: float
@export var shockwave_falloff: bool
@export var max_shockwaves: int = 1
@export var shockwave_cooldown: int = 1

var collider: CollisionShape2D
var shockwaves: int
var time: int = 0

func _ready() -> void:
	monitoring = false
	collider = get_child(0)
	body_entered.connect(_on_body_entered)
	get_parent().shockwave.connect(create_shockwave)
	shockwaves = max_shockwaves
	
	
func _physics_process(delta: float) -> void:
	if monitoring:
		var bodies = get_overlapping_bodies()
		push_away(bodies)
	if collider.scale.length() >= shockwave_radius:
		monitoring = false
		collider.scale = Vector2.ONE
		
	time += 1
	if time % shockwave_cooldown == 0 && shockwaves < max_shockwaves:
		shockwaves += 1
	

func create_shockwave() -> void:
	if shockwaves > 0:
		monitoring = true
		var tween = get_tree().create_tween()
		var tween_prop = tween.tween_property(collider, 
		"scale", 
		Vector2(shockwave_radius, shockwave_radius), 
		shockwave_duration)
		tween_prop.set_trans(Tween.TRANS_LINEAR)
		shockwaves -= 1
	
func _on_body_entered(body) -> void:
	apply_damage(body)
		
func apply_damage(body) -> void:   
	var health = body.get_node("Health")
	if is_instance_valid(health):
		health.take_damage(damage)
		
func push_away(bodies) -> void:
	for body in bodies:
		if body is CharacterBody2D:
			var direction = (body.global_position - global_position).normalized()
			var distance = global_position.distance_to(body.global_position)
			var strength = shockwave_strength
			if shockwave_falloff:
				strength *= max(0, 1 - (distance / shockwave_radius))  # Linear falloff
			body.velocity = direction * strength
			body.move_and_slide()