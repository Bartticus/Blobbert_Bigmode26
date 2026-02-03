class_name LevelScript
extends Node2D

@onready var camera: Camera2D = %Camera
@onready var blob: Blob = %Blob

@export var starting_level: Marker2D:
	set(value):
		starting_level = value
		#Global.blob._on_blob_level_transition_area_area_exited


func _ready() -> void:
	Global.level = self
	Global.blob = blob
	for screen in get_tree().get_nodes_in_group('screens'):
		screen.disable_screen_elements()
