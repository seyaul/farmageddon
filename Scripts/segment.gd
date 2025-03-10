extends RigidBody2D
class_name Segment

signal shoot
signal took_damage(damage: int)

var lgun: Sprite2D
var rgun: Sprite2D

func _ready() -> void:
	add_to_group("mobs")

func take_damage(damage: int):
	took_damage.emit(damage)