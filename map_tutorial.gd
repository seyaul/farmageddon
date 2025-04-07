extends Control

var tutorial_steps = ["monster", "elite", "treasure", "campfire", "boss"]
var curr_step: int = 0
var step_labels: Dictionary = {} 

signal tutorial_completed

func _ready():
	hide_all_except_monster()
	if Global.map_tutorial:
		curr_step = 0
		start_step(curr_step)

func _input(event: InputEvent):
	if Global.map_tutorial and event.is_action_pressed("melee"):
		advance_tutorial()
	elif event.is_action_pressed("skip_tutorial"):
		print("skipped lol")
		skip_tutorial()

func start_step(step_idx: int):
	hide_all()
	match step_idx:
		0:
			$MonsterPrompt.visible = true
		1:
			$ElitePrompt.visible = true
		2:
			$TreasurePrompt.visible = true
		3:
			$CampfirePrompt.visible = true
		4:
			$BossPrompt.visible = true

func advance_tutorial():
	curr_step += 1
	if curr_step >= tutorial_steps.size():
		hide_all()
		Global.map_tutorial = false
		emit_signal("tutorial_completed")
		queue_free()
	else:
		start_step(curr_step)

func skip_tutorial():
	hide_all()
	Global.map_tutorial = false
	emit_signal("tutorial_completed")
	queue_free()

func hide_all_except_monster():
	$MonsterPrompt.visible = true
	$ElitePrompt.visible = false
	$TreasurePrompt.visible = false
	$CampfirePrompt.visible = false
	$BossPrompt.visible = false

func hide_all():
	$MonsterPrompt.visible = false
	$ElitePrompt.visible = false
	$TreasurePrompt.visible = false
	$CampfirePrompt.visible = false
	$BossPrompt.visible = false
