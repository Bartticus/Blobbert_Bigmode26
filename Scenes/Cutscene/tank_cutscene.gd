extends Node2D

@onready var tank: MultiScreenTemplate = %Tank
@onready var door_and_panel: MultiScreenTemplate = %DoorAndPanel
@onready var timer: Timer = %Timer

@export var vent_blocker: Node2D
@export var skipping_cutscene: bool = false
@onready var skip_cutscene_ui = %SkipCutscene

var tween_0: Tween = create_tween()
var tween_1: Tween = create_tween()
var tween_2: Tween = create_tween()

func trigger_action():
	skip_cutscene_ui.start_cutscene()
	Global.level.playing_cutscene = true
	await get_tree().create_timer(0.4).timeout
	if !skipping_cutscene:
		tween_0 = Global.level.tween_camera('position', tank.screens[0].global_position, 1.0, Tween.TRANS_SINE)
		await tween_0.finished
		await Global.level.enter_multi_screen(tank)
	Global.level.level_title_card.scale = Vector2(2,2)
	await Global.level.display_title_card()
	if !skipping_cutscene:
		tween_1 = Global.level.tween_camera('position', door_and_panel.screens[0].global_position, 5.0, Tween.TRANS_SINE)
		await tween_1.finished
		tween_2 = Global.level.tween_camera('position', tank.screens[0].global_position, 3.0, Tween.TRANS_SINE, 1.0)
		await tween_2.finished
	vent_blocker.process_mode = PROCESS_MODE_INHERIT
	Global.level.playing_cutscene = false

func _on_timer_timeout() -> void:
	trigger_action()


func _on_trigger_scene_area_entered(area: Area2D) -> void:
	if area.name == 'BlobLevelTransitionArea':
		timer.start()

func skip_cutscene():
	tween_0.kill()
	tween_1.kill()
	tween_2.kill()
	Global.level.playing_cutscene = false
	skipping_cutscene = true
	Global.blob.reset_screen()
