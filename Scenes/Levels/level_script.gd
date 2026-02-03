class_name LevelScript
extends Node2D

@onready var camera: Camera2D = %Camera
@onready var blob: Blob = %Blob
@onready var screens: Node2D = %Screens

@export var starting_screen: Screen
@export var current_anchor: Marker2D:
	set(value):
		current_anchor = value
		camera.global_position = current_anchor.global_position


func _ready() -> void:
	Global.level = self
	Global.blob = blob
	for screen in get_tree().get_nodes_in_group('screens'):
		screen.disable_screen_elements()
	
	if !starting_screen:
		starting_screen = screens.get_children()[0]
		current_anchor = starting_screen.screen_anchor
		blob.global_position = starting_screen.screen_blob.global_position
