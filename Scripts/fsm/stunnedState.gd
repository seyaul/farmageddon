extends State
class_name StunnedState

@export var stunned_seconds: float = 2
var seconds_left: float
var enemy: CharacterBody2D


func Enter():
    enemy = self.get_parent().get_parent()
    enemy.play_stun_animation()
    seconds_left = stunned_seconds

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Update(delta: float) -> void:
    seconds_left -= delta 
    if seconds_left <= 0:
        state_transition.emit(self, "Follow")

func Exit():
    enemy.stop_stun_animation()
