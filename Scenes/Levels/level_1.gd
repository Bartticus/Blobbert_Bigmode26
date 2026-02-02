extends Node2D

@export var camera: Camera2D
@export var current_anchor: Marker2D:
	set(value):
		current_anchor = value
		camera.global_position = current_anchor.global_position

@onready var trans_areas_node: Node2D = %CameraTransitionAreas
@onready var anchors_node: Node2D = %Anchors

var anchors: Array[Marker2D]
var camera_trans_areas: Array[Area2D]


func _ready() -> void:
	for child in trans_areas_node.get_children():
		if child is Area2D:
			camera_trans_areas.append(child)
	
	for child in anchors_node.get_children():
		if child is Marker2D:
			anchors.append(child)
	
	for area in camera_trans_areas:
		area.connect("area_exited", _on_screen_area_exited)

func _on_screen_area_exited(area: Area2D) -> void:
	var new_screen: String = area.get_overlapping_areas()[0].name
	var new_anchor: Marker2D = anchors[new_screen.right(new_screen.length() - 6).to_int()]
	
	current_anchor = new_anchor
