extends RigidBody2D
class_name Segment

signal shoot
signal took_damage(damage: int)

var lgun: Sprite2D
var rgun: Sprite2D

func take_damage(damage: int):
	print("in segment's take_damage")
	took_damage.emit(damage)