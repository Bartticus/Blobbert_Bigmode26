extends Node2D

@onready var tank: MultiScreenTemplate = %Tank
@onready var door_and_panel: MultiScreenTemplate = %DoorAndPanel
@onready var timer: Timer = %Timer


func trigger_action():
	Global.level.playing_cutscene = true
	await get_tree().create_timer(0.4).timeout
	var tween_0 = Global.level.tween_camera('position', tank.screens[0].global_position, 1.0, Tween.TRANS_SINE)
	await tween_0.finished
	Global.level.enter_multi_screen(tank)
	await get_tree().create_timer(1.0).timeout
	var tween_1 = Global.level.tween_camera('position', door_and_panel.screens[0].global_position, 5.0, Tween.TRANS_SINE)
	await tween_1.finished
	var tween_2 = Global.level.tween_camera('position', tank.screens[0].global_position, 3.0, Tween.TRANS_SINE, 1.0)
	await tween_2.finished
	Global.level.playing_cutscene = false
	


func _on_timer_timeout() -> void:
	trigger_action()


func _on_trigger_scene_area_entered(area: Area2D) -> void:
	if area.name == 'BlobLevelTransitionArea':
		timer.start()
