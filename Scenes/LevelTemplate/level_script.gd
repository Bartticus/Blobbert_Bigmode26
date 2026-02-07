class_name LevelScript
extends Node2D

@onready var camera: Camera2D = %Camera
@onready var blob: Blob = %Blob
@onready var screens: Node2D = %Screens
@onready var full_keeb: FullKeeb = %FullKeeb

@export var is_multi_screen: bool = false
@export var zoom_time: float = 0.25
@export var screen_render_distance_x: int = 3
@export var screen_render_distance_y: int = 4
@export var starting_screen: Screen
@export var current_anchor: Marker2D:
	set(value):
		current_anchor = value
		camera.global_position = current_anchor.global_position


func _ready() -> void:
	Global.level = self
	Global.blob = blob

	if !starting_screen:
		starting_screen = screens.get_children()[0]

	for screen in get_tree().get_nodes_in_group('screens'):
		screen.disable_screen_elements()
	
	current_anchor = starting_screen.screen_anchor
	blob.global_position = starting_screen.screen_blob.global_position
	Fade.fade_in(0.5)

func enter_multi_screen(multi_screen):
	is_multi_screen = true
	Engine.time_scale = 0.3
	var camera_zoom = Vector2(0.5, 0.5)
	var keeb_scale = Vector2(2.0, 2.0)
	var tween = get_tree().create_tween()
	tween.set_parallel()
	current_anchor = multi_screen.screens[0].screen_anchor
	if camera.zoom != camera_zoom:
		tween.tween_property(camera, 'zoom', camera_zoom, zoom_time)
	if full_keeb.scale != keeb_scale:
		tween.tween_property(full_keeb, 'scale', keeb_scale, zoom_time).set_delay(0.05)
	
	await tween.finished
	Engine.time_scale = 1.0

func enter_single_screen(screen):
	current_anchor = screen.screen_anchor
	if is_multi_screen:
		Engine.time_scale = 0.3
		var standard_vector = Vector2(1.0, 1.0)
		var tween = get_tree().create_tween()
		tween.set_parallel()

		if camera.zoom != standard_vector:
			tween.tween_property(camera, 'zoom', standard_vector, zoom_time)
		if full_keeb.scale != standard_vector:
			tween.tween_property(full_keeb, 'scale', standard_vector, zoom_time).set_delay(0.05)

		await tween.finished
		Engine.time_scale = 1.0
	is_multi_screen = false
