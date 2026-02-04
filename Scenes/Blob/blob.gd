class_name Blob
extends Node2D

@export var softbody: SoftBody2D
@export var bodies: Array[Bone] = []

@export var oil_scene: PackedScene
@export var oils_parent: Node2D

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
			child.connect("body_entered", _on_bone_body_entered.bind(child))
	
	for child in face_pivot.get_children():
		if child is Sprite2D:
			face_array.append(child)

func _on_bone_body_entered(body: Node2D, bone: Bone) -> void:
	#check if a new oil should spawn
	var min_speed: float = 100.0
	if bone.in_oil_area or bone.linear_velocity.length() < min_speed: return
	
	if body is CollisionObject2D:
		if body.collision_layer != 1:
			return
	
	#instantiate
	var oil: Oil = oil_scene.instantiate()
	body.call_deferred("add_child", oil)
	
	#set position
	var state = PhysicsServer2D.body_get_direct_state(bone.get_rid())
	var coll_pos = state.get_contact_collider_position(0)
	var coll_normal = state.get_contact_local_normal(0)
	oil.global_position = coll_pos - body.global_position
	
	#set scale
	var bone_speed: float = bone.linear_velocity.length()
	var scale_ratio: float = bone_speed / 1000
	if scale_ratio > 2.0:
		scale_ratio = 2.0
	oil.scale = oil.scale * scale_ratio
	
	#set rotation
	oil.look_at(coll_pos - body.global_position + coll_normal)
	oil.rotation_degrees += 90
	
	#prevent more oils from spawning
	bone.oil_areas_int += 1

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
