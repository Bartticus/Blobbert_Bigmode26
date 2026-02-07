extends Node2D

@onready var tank: MultiScreenTemplate = %Tank
@onready var door_and_panel: MultiScreenTemplate = %DoorAndPanel
@onready var timer: Timer = %Timer


func trigger_action():
	Global.level.playing_cutscene = true
	await get_tree().create_timer(2.0).timeout
	var tween_0 = Global.level.tween_camera('position', door_and_panel.screens[0].global_position, 5.0, Tween.TRANS_SINE)
	await tween_0.finished
	var tween_1 = Global.level.tween_camera('position', tank.screens[0].global_position, 5.0, Tween.TRANS_SINE, 1.0)
	await tween_1.finished
	Global.level.playing_cutscene = false
	


func _on_timer_timeout() -> void:
	trigger_action()


func _on_trigger_scene_area_entered(area: Area2D) -> void:
	if area.name == 'BlobLevelTransitionArea':
		timer.start()
