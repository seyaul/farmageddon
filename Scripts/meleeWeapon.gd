extends Area2D

@export var damage: float
# NOTE: Only here for debugging. 
@export var melee_duration: float = 100
# TODO: Replace with timer?
@export var disabled: bool
var time: int = 0

signal enemy_god_mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	self.connect("enemy_god_mode", Callable(self, "_on_enemy_god_mode"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	time += 1
	if time >= melee_duration:
		queue_free()
	if Input.is_action_just_pressed("enemy_god_mode"):
		emit_signal("enemy_god_mode")

func _on_body_entered(body) -> void:
	if body.name == "Player":
		if !disabled:
			body.take_damage(damage)	
		
func _on_enemy_god_mode():
	#print("enemy god mode activated")
	damage = 100
