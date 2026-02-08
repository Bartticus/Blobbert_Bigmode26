@tool
class_name Screen
extends Node2D

@onready var screen_full_keeb: FullKeeb = %ScreenFullKeeb
@onready var screen_anchor: Marker2D = %ScreenAnchor
@onready var screen_blob: Blob = %ScreenBlob
@onready var camera: Camera2D = %ScreenCamera
@onready var world_env: WorldEnvironment = %WorldEnvironment

@export var x_coordinate : int
@export var y_coordinate : int
@export var multi_screen: MultiScreenTemplate

@export var snap_screen_to_position: bool = false:
	set(value):
		snap_screen_to_position = value
		if snap_screen_to_position and Engine.is_editor_hint():
			set_screen_position()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('screens')
	set_screen_position()

func disable_screen_elements():
	screen_full_keeb.queue_free()
	if screen_blob:
		screen_blob.queue_free()
	camera.queue_free()
	world_env.queue_free()


func set_screen_position():
	if x_coordinate is int && y_coordinate is int:
		global_position = Vector2(1920 * x_coordinate, 1080 * y_coordinate)
