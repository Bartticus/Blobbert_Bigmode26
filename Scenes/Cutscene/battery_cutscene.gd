extends Node2D

@export var battery: Battery
@onready var tank: MultiScreenTemplate = %Tank

func _ready():
	battery.cutscene = self


func trigger_action():
	Global.level.playing_cutscene = true
	await Global.level.enter_multi_screen(tank)
	var tween_0 = Global.level.tween_camera('position', tank.screens[2].global_position, 3.0, Tween.TRANS_SINE)
	await tween_0.finished
	for to in battery.triggerable_objects:
		to.trigger_action()
	await get_tree().create_timer(3.0).timeout
	Global.level.playing_cutscene = false
	Global.blob.reset_screen()

