class_name Blob
extends Node2D

@export_category("Bodies")
@export var softbody: SoftBody2D
@export var bodies: Array[Bone] = []
var center_bone: Bone2D

@export_category("Oil")
@export var oil_scene: PackedScene
@export var oil_timer: Timer
var newly_spawned_oil: Oil

@export_category("Face")
@export var face_pivot: Node2D
@export var face_array: Array[Sprite2D]
@export var rand_face_timer: Timer
@export var set_face_timer: Timer

@onready var current_face: Sprite2D = %Neutral
@onready var blob_level_transition_area: Area2D = %BlobLevelTransitionArea
@onready var blob_visibility_notifier: VisibleOnScreenNotifier2D = %BlobVisibilityNotifier
@onready var blob_center: Marker2D = %BlobCenter
@onready var swirl_rect: ColorRect = %SwirlRect

enum Status { DEFAULT, STRETCHED, FAST, HURT, IDLE }
var status: Status = Status.IDLE: set = set_status


func _ready() -> void:
	Global.blob = self
	center_bone = softbody.get_center_body().bone
	
	for child in softbody.get_children():
		if child is Bone:
			bodies.append(child)
			child.connect("body_entered", _on_bone_body_entered.bind(child))
			# Uncomment this to add oil to tilemap
			# child.connect("body_shape_entered", _on_bone_collision)
	
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
	var center_pos = softbody.get_bones_center_position()
	blob_center.global_position = center_pos
	swirl_rect.global_position = center_pos - Vector2(270+82,244+87) #anchors, man
	
	var weight = 0.05
	blob_center.rotation = lerp_angle(blob_center.rotation, center_bone.rotation, weight)
	
	if Input.is_action_just_pressed('reset'):
		get_tree().reload_current_scene()

func _on_blob_level_transition_area_area_exited(_area: Area2D) -> void:
	# reset_screen()
	pass

func reset_screen():
	for overlapping_area in blob_level_transition_area.get_overlapping_areas():
		if overlapping_area.name == 'ScreenSpace':
			Global.level.current_anchor = overlapping_area.get_owner().screen_anchor

func _on_bone_body_entered(body: Node2D, bone: Bone) -> void:
	#check if a new oil should spawn
	if !oil_timer.is_stopped(): return
	
	if bone.in_oil_area: return
	
	if body is CollisionObject2D:
		if body.collision_layer != 1:
			return
	
	#change softbody physics when an oil is created, reverted when that oil area is exited
	softbody.physics_material_override.friction = 1.0
	#softbody.mass = 0.2
	
	#add pivot point
	var oil_pivot: Node2D = Node2D.new()
	body.call_deferred("add_child", oil_pivot)
	
	#instantiate oil
	var oil: Oil = oil_scene.instantiate()
	oil_pivot.call_deferred("add_child", oil)
	newly_spawned_oil = oil
	
	#set position
	var state = PhysicsServer2D.body_get_direct_state(bone.get_rid())
	var coll_pos = state.get_contact_collider_position(0) - body.global_position
	var coll_normal = state.get_contact_local_normal(0)
	oil.global_position = coll_pos
	
	#set scale
	var bone_speed: float = bone.linear_velocity.length()
	var scale_ratio: float = bone_speed / 1000
	scale_ratio = clampf(scale_ratio, 0.3, 2.0)
	oil.scale = oil.scale * scale_ratio
	
	#set rotation
	oil_pivot.rotation -= body.rotation
	oil.look_at(coll_pos + coll_normal)
	oil.rotation_degrees += 90
	
	#cooldown period
	oil_timer.start()


func _on_screen_fail_safe_timeout() -> void:
	if !blob_visibility_notifier.is_on_screen():
		reset_screen()


func _on_oil_detector_area_exited(area: Area2D) -> void:
	if area is Oil:
		if area == newly_spawned_oil:
			softbody.physics_material_override.friction = 0.2
			#softbody.mass = 0.05


func _on_blob_visibility_notifier_screen_exited() -> void:
	reset_screen()
