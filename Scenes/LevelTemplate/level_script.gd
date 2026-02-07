class_name LevelScript
extends Node2D

@onready var camera: Camera2D = %Camera
@onready var blob: Blob = %Blob
@onready var screens: Node2D = %Screens

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
