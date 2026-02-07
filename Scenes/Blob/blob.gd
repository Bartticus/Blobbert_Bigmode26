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
@export var rand_face_timer: Timer
@export var set_face_timer: Timer
@export var default_faces: Array[Sprite2D]
var face_dict: Dictionary = {}

@onready var blob_level_transition_area: Area2D = %BlobLevelTransitionArea
@onready var blob_visibility_notifier: VisibleOnScreenNotifier2D = %BlobVisibilityNotifier
@onready var blob_center: Marker2D = %BlobCenter
@onready var swirl_rect: ColorRect = %SwirlRect
@onready var current_face: Sprite2D = %Neutral:
	set(value):
		current_face.hide()
		current_face = value
		current_face.show()

enum Status {DEFAULT, STRETCHED, FAST, SLOWING, HURT, IDLE, ASLEEP}
var status: Status = Status.IDLE: set = set_status

var start_time = Time.get_ticks_msec()
var just_hurt: bool = false
var moving_fast: bool = false
var previous_vel: float
var new_vel: float


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
			face_dict[child.name] = child

func set_status(new_status) -> void:
	if status == new_status: return
	
	status = new_status
	match status:
		Status.DEFAULT:
			rand_face_timer.start(randf_range(0.5, 3.0))
		Status.STRETCHED:
			current_face = face_dict["Argh"]
		Status.FAST:
			current_face = face_dict["Whoa"]
		Status.SLOWING:
			current_face = face_dict["Yikes"]
		Status.HURT:
			current_face = face_dict["Angry"]
		Status.IDLE:
			current_face = face_dict["Neutral"]
		Status.ASLEEP:
			current_face = face_dict["Sleepy"]

func check_status() -> void:
	if !set_face_timer.is_stopped(): return
	set_face_timer.start()
	
	var new_status: Status
	new_status = Status.DEFAULT
	
	var number_of_tuggers: int = get_tree().get_nodes_in_group("tugging_keys").size()
	if number_of_tuggers >= 4:
		new_status = Status.STRETCHED
	
	if moving_fast:
		new_status = Status.FAST
	elif status == Status.FAST:
		new_status = Status.SLOWING
	
	if just_hurt:
		new_status = Status.HURT
		just_hurt = false
	
	if new_status == Status.DEFAULT:
		if number_of_tuggers >= 1:
			start_time = Time.get_ticks_msec()
		
		var elapsed_time = Time.get_ticks_msec() - start_time
		if elapsed_time > 15000:
			new_status = Status.ASLEEP
		elif elapsed_time > 10000:
			new_status = Status.IDLE
	else:
		start_time = Time.get_ticks_msec()
	
	status = new_status

func _on_rand_face_timer_timeout() -> void:
	if status != Status.DEFAULT: return
	
	var new_face: Sprite2D = default_faces.pick_random()
	while new_face == current_face:
		new_face = default_faces.pick_random()
	
	current_face = new_face
	
	rand_face_timer.start(randf_range(0.5, 3.0))

func _on_set_face_timer_timeout() -> void:
	check_status()

func _physics_process(_delta: float) -> void:
	var center_pos = softbody.get_bones_center_position()
	blob_center.global_position = center_pos
	swirl_rect.global_position = center_pos - Vector2(270 + 82, 244 + 87) # anchors, man
	var weight = 0.05
	blob_center.rotation = lerp_angle(blob_center.rotation, center_bone.rotation, weight)
	
	check_moving_fast()
	
	if Input.is_action_just_pressed('reset'):
		get_tree().reload_current_scene()

func check_moving_fast() -> void:
	new_vel = softbody.get_center_body().rigidbody.linear_velocity.length()
	if previous_vel < 1000 and new_vel >= 1000:
		moving_fast = true
		check_status()
	if previous_vel > 1000 and new_vel <= 1000:
		moving_fast = false
		check_status()
	previous_vel = softbody.get_center_body().rigidbody.linear_velocity.length()

func _on_blob_level_transition_area_area_exited(_area: Area2D) -> void:
	# reset_screen()
	pass

func reset_screen():
	for overlapping_area in blob_level_transition_area.get_overlapping_areas():
		if overlapping_area.name == 'ScreenSpace':
			if overlapping_area.get_owner().multi_screen:
				Global.level.enter_multi_screen(overlapping_area.get_owner().multi_screen)
			else:
				Global.level.enter_single_screen(overlapping_area.get_owner())

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
	oil_pivot.scale = Vector2.ONE / body.scale
	var bone_speed: float = bone.linear_velocity.length()
	var scale_ratio: float = bone_speed / 1000
	scale_ratio = clampf(scale_ratio, 0.3, 2.0)
	oil.scale = oil.scale * scale_ratio
	
	if oil.scale.length() > 2: # For angry face
		just_hurt = true
		check_status()
	
	#set rotation
	oil_pivot.rotation -= body.owner.rotation
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
