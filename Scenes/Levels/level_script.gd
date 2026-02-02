class_name LevelScript
extends Node2D

@onready var camera: Camera2D = %Camera
@onready var trans_areas_node: Node2D = %CameraTransitionAreas
@onready var anchors_node: Node2D = %Anchors

var anchors: Array[Marker2D]
var camera_trans_areas: Array[Area2D]

@export var current_anchor: Marker2D:
	set(value):
		current_anchor = value
		camera.global_position = current_anchor.global_position


func _ready() -> void:
	Global.level = self
