extends Node2D

var loading_screen: PackedScene = preload('res://Scenes/Levels/loading_screen.tscn')
@export var next_scene: String = 'res://Scenes/Levels/vent_level.tscn'

func _on_loading_area_area_entered(area: Area2D) -> void:
	if area.name == 'BlobLevelTransitionArea':
		load_next()

func load_next():
	Global.current_level = get_tree().current_scene.scene_file_path
	await Fade.fade_out(0.5).finished
	get_tree().change_scene_to_packed(loading_screen)
		
