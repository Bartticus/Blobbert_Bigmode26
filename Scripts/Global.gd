extends Node

var physics_fps = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")

var blob: Blob
var level: LevelScript = null
var max_tug_power: float = 4000 * physics_fps
var max_multi_screen_tug_power: float = 5750 * physics_fps
var tug_power: float = max_tug_power

var max_tug_range: float = 750
var max_multi_screen_tug_range: float = 1250
var tug_range: float = max_tug_range

var current_level: String
var should_transition: bool = false

var sound_manager: Node2D

var key_count: int = 0
var time_score: int = 0
var start_time: float

var user_name: String = ''

var posting_score: bool = false

var level_order = {
	'res://Scenes/Levels/opening_scene.tscn': 'res://Scenes/Levels/lab_level.tscn',
	'res://Scenes/Levels/lab_level.tscn': 'res://Scenes/Levels/vent_level.tscn',
	'res://Scenes/Levels/vent_level.tscn': 'res://Scenes/Levels/tank_level.tscn',
	'res://Scenes/Levels/tank_level.tscn': 'res://Scenes/Levels/bunsen_level.tscn',
	'res://Scenes/Levels/bunsen_level.tscn': 'res://Scenes/Levels/win_screen.tscn'
	}

func ready():
	randomize()

func load_next_scene():
	should_transition = true
	get_tree().change_scene_to_file(level_order.get(current_level))


func iterate_key_count():
	key_count += 1

func playing_cutscene():
	if level:
		return level.playing_cutscene
	else:
		return false
