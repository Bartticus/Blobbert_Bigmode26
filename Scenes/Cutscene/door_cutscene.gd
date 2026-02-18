extends Node2D

@export var tank_glass: Node2D
@onready var tank: MultiScreenTemplate = %Tank
@onready var door: MultiScreenTemplate = %DoorAndPanel

func _ready():
	tank_glass.cutscene = self


func trigger_action():
	Global.level.playing_cutscene = true
	var tween_0 = Global.level.tween_camera('position', door.screens[0].global_position - Vector2(250, 0), 2.0, Tween.TRANS_SINE)
	await tween_0.finished
	Global.audio_manager.play_required_sound('glass_break')
	for to in tank_glass.triggerable_objects:
		await get_tree().create_timer(0.02).timeout
		to.trigger_action()
	await get_tree().create_timer(3.0).timeout
	Global.level.playing_cutscene = false
	Global.blob.reset_screen()
