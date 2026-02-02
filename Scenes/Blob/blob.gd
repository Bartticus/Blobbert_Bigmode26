class_name Blob
extends Node2D

@export var softbody: SoftBody2D
@export var bodies: Array[Bone] = []

@export var face_pivot: Node2D
@export var face_array: Array[Sprite2D]
@onready var current_face: Sprite2D = $BlobCenter/FacePivot/Neutral

func _ready() -> void:
	Global.blob = self
	
	for child in softbody.get_children():
		if child is Bone:
			bodies.append(child)
	
	for child in face_pivot.get_children():
		if child is Sprite2D:
			face_array.append(child)


func _on_timer_timeout() -> void:
	current_face.hide()
	
	var new_face: Sprite2D = face_array.pick_random()
	while new_face == current_face:
		new_face = face_array.pick_random()
	
	current_face = new_face
	current_face.show()
	
	$Timer.start(randf_range(0.5, 3.0))
