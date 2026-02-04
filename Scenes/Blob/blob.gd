class_name Blob
extends Node2D

@export var softbody: SoftBody2D
@export var bodies: Array[Bone] = []

@export var face_pivot: Node2D
@export var face_array: Array[Sprite2D]
@export var rand_face_timer: Timer
@export var set_face_timer: Timer

@onready var current_face: Sprite2D = %Neutral
@onready var blob_level_transition_area: Area2D = %BlobLevelTransitionArea

enum Status { DEFAULT, STRETCHED, FAST, HURT, IDLE }
var status: Status = Status.IDLE: set = set_status


func _ready() -> void:
	Global.blob = self
	
	for child in softbody.get_children():
		if child is Bone:
			bodies.append(child)
			child.connect("body_shape_entered", _on_bone_collision)
	
	for child in face_pivot.get_children():
		if child is Sprite2D:
			face_array.append(child)

func _on_bone_collision(body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		set_tile_oil(body, body_rid)

func set_tile_oil(body: TileMapLayer, body_rid: RID):
	var collided_tile_coords = body.get_coords_for_body_rid(body_rid)
	body.set_cell(
		collided_tile_coords,
		body.get_cell_source_id(collided_tile_coords),
		body.get_cell_atlas_coords(collided_tile_coords),
		1
	)
	

func set_status(new_status) -> void:
	status = new_status
	match status:
		Status.DEFAULT:
			rand_face_timer.start(randf_range(0.5, 3.0))
		Status.STRETCHED:
			pass
		Status.FAST:
			pass
		Status.HURT:
			pass
		Status.IDLE:
			pass

func _on_rand_face_timer_timeout() -> void:
	current_face.hide()
	
	var new_face: Sprite2D = face_array.pick_random()
	while new_face == current_face:
		new_face = face_array.pick_random()
	
	current_face = new_face
	current_face.show()
	
	rand_face_timer.start(randf_range(0.5, 3.0))

func _on_set_face_timer_timeout() -> void:
	set_status(Status.DEFAULT)

func _process(_delta: float) -> void:
	%SwirlRect.global_position = %"Bone-13".global_position - Vector2(270+82,244+87)
	if Input.is_action_just_pressed('reset'):
		get_tree().reload_current_scene()

func _on_blob_level_transition_area_area_exited(_area: Area2D) -> void:
	for overlapping_area in blob_level_transition_area.get_overlapping_areas():
		if overlapping_area.name == 'ScreenSpace':
			Global.level.current_anchor = overlapping_area.get_owner().screen_anchor

func get_tile_oil() -> float:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	
	if not tilemap:
		return 1
	
	var cell := tilemap.local_to_map(position)
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var oil_level: float = data.get_custom_data("oil")
		if oil_level > 0:
			return oil_level
	
	return 1
