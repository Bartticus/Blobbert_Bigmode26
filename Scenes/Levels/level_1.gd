extends Node2D

@export var camera: Camera2D
@export var anchors: Array[Marker2D]
@export var camera_trans_areas: Array[Area2D]
@export var current_anchor: Marker2D:
	set(value):
		current_anchor = value
		camera.global_position = current_anchor.global_position


func _ready() -> void:
	for area in camera_trans_areas:
		area.connect("area_exited", _on_screen_area_exited)

func _on_screen_area_exited(area: Area2D) -> void:
	var new_screen: String = area.get_overlapping_areas()[0].name
	var new_anchor: Marker2D = anchors[new_screen.right(new_screen.length() - 6).to_int()]
	
	current_anchor = new_anchor
