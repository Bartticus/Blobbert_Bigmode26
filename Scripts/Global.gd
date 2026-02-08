extends Node


var blob: Blob
var level: LevelScript = null
var key_count: int = 0
var max_tug_power: float = 4000
var max_multi_screen_tug_power: float = 5750
var tug_power: float = 4000

var max_tug_range: float = 750
var max_multi_screen_tug_range: float = 1250
var tug_range: float = 750

var current_level: String
var should_transition: bool = false

var audio_manager: Node2D

var level_order = {
	'res://Scenes/Levels/opening_scene.tscn': 'res://Scenes/Levels/lab_level.tscn',
	'res://Scenes/Levels/lab_level.tscn': 'res://Scenes/Levels/vent_level.tscn',
	'res://Scenes/Levels/vent_level.tscn': 'res://Scenes/Levels/tank_level.tscn',
	'res://Scenes/Levels/tank_level.tscn': 'res://Scenes/Levels/bunsen_level.tscn',
	'res://Scenes/Levels/bunsen_level.tscn': 'res://Scenes/Levels/loading_screen.tscn'
	}

func ready():
	randomize()


func load_next_scene():
	should_transition = true
	get_tree().change_scene_to_file(level_order.get(current_level))


func iterate_key_count():
	key_count += 1
