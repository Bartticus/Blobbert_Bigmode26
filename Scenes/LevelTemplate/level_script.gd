class_name LevelScript
extends Node2D

@onready var camera: Camera2D = %Camera
@onready var blob: Blob = %Blob
@onready var screens: Node2D = %Screens
@onready var full_keeb: FullKeeb = %FullKeeb
@onready var sound_manager: = %SoundManager

@export var playing_cutscene: bool = false:
	set(new_value):
		playing_cutscene = new_value
		match playing_cutscene:
			true:
				var tween = get_tree().create_tween()
				tween.set_ignore_time_scale()
				tween.tween_property(full_keeb, 'modulate', Color(1.0, 1.0, 1.0, 0.0), 0.1)
			false:
				var tween = get_tree().create_tween()
				tween.set_ignore_time_scale()
				tween.tween_property(full_keeb, 'modulate', Color(1.0, 1.0, 1.0, 1.0), 0.1)

@export var is_multi_screen: bool = false
@export var zoom_time: float = 0.25
@export var zoom_time_scale: float = 0.3
@export var screen_render_distance_x: int = 3
@export var screen_render_distance_y: int = 4
@export var starting_screen: Screen
@export var current_anchor: Marker2D:
	set(value):
		current_anchor = value
		var tween_0 = tween_camera('global_position', current_anchor.global_position, 0.1, Tween.TRANS_SINE)
		tween_0.set_ignore_time_scale()
		await tween_0.finished
		# camera.global_position = current_anchor.global_position


func _ready() -> void:
	if name == "LabLevel":
		Global.start_time = Time.get_ticks_msec()
		Global.key_count = 0
	
	Global.level = self
	Global.blob = blob
	Global.sound_manager = sound_manager
	if Global.should_transition:
		starting_screen = null

	if !starting_screen:
		starting_screen = screens.get_children()[0]

	for screen in get_tree().get_nodes_in_group('screens'):
		screen.disable_screen_elements()
	
	blob.global_position = starting_screen.screen_blob.global_position
	await get_tree().process_frame
	Global.blob.reset_screen()
	Fade.fade_in(0.5)

func enter_multi_screen(multi_screen):
	var is_in_cutscene = playing_cutscene
	current_anchor = multi_screen.screens[0].screen_anchor
	if !is_multi_screen:
		if !is_in_cutscene:
			playing_cutscene = true
		Global.tug_power = Global.max_multi_screen_tug_power
		Global.tug_range = Global.max_multi_screen_tug_range
		Engine.time_scale = zoom_time_scale
		var camera_zoom = Vector2(0.5, 0.5)
		var keeb_scale = Vector2(2.0, 2.0)
		var tween = get_tree().create_tween()
		tween.set_parallel()

		if camera.zoom != camera_zoom:
			tween.tween_property(camera, 'zoom', camera_zoom, zoom_time)
		if full_keeb.scale != keeb_scale:
			tween.tween_property(full_keeb, 'scale', keeb_scale, zoom_time).set_delay(0.05)

		await tween.finished
		Engine.time_scale = 1.0
		if !is_in_cutscene:
			playing_cutscene = false
	is_multi_screen = true

func enter_single_screen(screen):
	var is_in_cutscene = playing_cutscene
	Global.tug_power = Global.max_tug_power
	Global.tug_range = Global.max_tug_range
	current_anchor = screen.screen_anchor
	if is_multi_screen:
		if !is_in_cutscene:
			playing_cutscene = true
		Engine.time_scale = zoom_time_scale
		var standard_vector = Vector2(1.0, 1.0)
		var tween = get_tree().create_tween()
		tween.set_parallel()

		if camera.zoom != standard_vector:
			tween.tween_property(camera, 'zoom', standard_vector, zoom_time)
		if full_keeb.scale != standard_vector:
			tween.tween_property(full_keeb, 'scale', standard_vector, zoom_time).set_delay(0.05)

		await tween.finished
		Engine.time_scale = 1.0
		if !is_in_cutscene:
			playing_cutscene = false
	is_multi_screen = false

func tween_camera(property = 'position', target = Vector2(0,0), tween_time = 1.0, transition_type = Tween.TRANS_LINEAR, delay = 0.0):
	var tween = get_tree().create_tween()
	tween.set_ignore_time_scale()
	tween.tween_property(camera, property, target, tween_time).set_trans(transition_type).set_delay(delay)
	return tween
