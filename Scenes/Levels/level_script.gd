class_name LevelScript
extends Node2D

@onready var camera: Camera2D = %Camera
@onready var blob: Blob = %Blob

@export var current_anchor: Marker2D:
	set(value):
		current_anchor = value
		camera.global_position = current_anchor.global_position


func _ready() -> void:
	Global.level = self
	Global.blob = blob
	for screen in get_tree().get_nodes_in_group('screens'):
		screen.disable_screen_elements()
