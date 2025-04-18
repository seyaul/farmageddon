extends State
class_name KnockedBackState

@export var knockback_decay = 0.10  # How quickly knockback wears off
var knockback_velocity: Vector2
var enemy: CharacterBody2D

func Enter():
	print("in knockback state")
	enemy = self.get_parent().get_parent()
	var knockback_timer = get_tree().create_timer(knockback_decay)
	knockback_timer.timeout.connect(_on_knockback_timeout)

func Update(delta):
	enemy.velocity = knockback_velocity
	enemy.move_and_slide()

# This is signaled on timeout to exit the lunge state
func _on_knockback_timeout():
	emit_signal("state_transition", self, "Follow")

func Exit():
	pass
