extends Node


var blob: Blob
var level: LevelScript = null
var key_count: int = 0

var level_order = ['res://Scenes/Levels/lab_level.tscn', 'res://Scenes/Levels/vent_level.tscn', 'res://Scenes/Levels/tank_level.tscn', 'res://Scenes/Levels/bunsen_level.tscn']
var current_level = 0

func iterate_level():
	current_level += 1

func load_next_scene():
	iterate_level()
	get_tree().change_scene_to_file(level_order[current_level])

func iterate_key_count():
	key_count += 1
