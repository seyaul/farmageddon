extends MarginContainer

# TODO: Handle healling logic
# TODO: Refator to not listen to input from keyboard but some sort of signal
@export var health: float
@export var animation_speed: float = 1.0

var sprite: AnimatedSprite2D
var max_frames:float
var curr_health: float
var playing: bool

func _ready() -> void:
	sprite = get_child(0)
	max_frames = sprite.get_sprite_frames().get_frame_count("default")
	curr_health = health

func _physics_process(delta: float) -> void:
	var threshold: float = 1 - (curr_health / health)
	var anim_progress: float = float(sprite.frame) / max_frames
	if anim_progress >= threshold and sprite.is_playing():
		sprite.pause()
		sprite.frame -= 1
	print(anim_progress, "    ", threshold)
	if Input.is_action_just_pressed("shoot"):
		curr_health = clamp(curr_health - 12.5, 0, health)
		sprite.play("default", animation_speed)
