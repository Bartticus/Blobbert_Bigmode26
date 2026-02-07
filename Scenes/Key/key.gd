@tool
class_name Key
extends Node2D

@onready var snap_timer: Timer = %SnapTimer
@onready var point_light_2d: PointLight2D = %PointLight2D
@onready var tug_rope: Line2D = %TugRope
@onready var key_label: Label = %KeyLabel

# Now stored in Global
# @export var Global.tug_range: float = 750
# @export var max_tug_power: float = 4000
@export var tug_decay: float = 3.0
@export var max_snap_multiplier: float = 12.0
@export var snap_timer_wait_time: float = 1.0
@export var max_tuggers: float = 25.0

@export var snap_keys_to_position: bool = false:
	set(value):
		snap_keys_to_position = value
		if snap_keys_to_position and Engine.is_editor_hint():
			set_key_positions()

func set_key_positions():
	print(key_label.text)
	print(name)
	set_key_label(str(name))

var current_bone: Bone : set = set_current_bone
var dist_to_current_bone: float
var force_applied: Vector2

enum Status { IDLE, TUGGING, SNAPPING }
const STATUS_GROUPS = {
	Status.IDLE: 'idle_keys',
	Status.TUGGING: 'tugging_keys',
	Status.SNAPPING: 'snapping_keys'
}
# Every time the 'status' is set, set_status will run and perform any side effects for the new status
var status: Status = Status.IDLE : set = set_status

func _ready() -> void:
	tug_rope.parent_key = self

func set_key_label(new_value):
	key_label.text = new_value

func set_status(new_status) -> void:
	status = new_status
	put_in_status_group()
	match status:
		Status.IDLE:
			point_light_2d.enabled = false
			current_bone = null
			snap_timer.stop()
			tug_rope.disable()
			force_applied = Vector2(0,0)
		Status.TUGGING:
			point_light_2d.enabled = true
			snap_timer.start(snap_timer_wait_time)
			Global.iterate_key_count()

# Remove from all other groups, and put in the group matching current status
func put_in_status_group():
	for group_name in STATUS_GROUPS.values():
		remove_from_group(group_name)
	add_to_group(STATUS_GROUPS.get(status, STATUS_GROUPS[Status.IDLE]))
	
	Global.blob.check_status()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and !event.is_echo():
		var key_string: String = OS.get_keycode_string(event.keycode)
		if key_string == name && status != Status.TUGGING:
			status = Status.TUGGING
	
	if event is InputEventKey and event.is_released():
		var key_string: String = OS.get_keycode_string(event.keycode)
		if key_string == name:
			if status != Status.SNAPPING:
				status = Status.SNAPPING
			else:
				status = Status.IDLE


func find_closest_bone() -> void:
	var closest_bone: Bone = null
	var shortest_dist: float
	var blob_bones = Global.blob.bodies
	for i in blob_bones.size():
		var bone = blob_bones[i]
		var dist_to_bone: float = global_position.distance_to(bone.global_position)
		if bone is Bone:
			if (bone.status != Bone.Status.FREE) && (bone != current_bone):
				continue
			
			if closest_bone == null:
				shortest_dist = dist_to_bone
				closest_bone = bone
			
			if dist_to_bone < shortest_dist:
				shortest_dist = dist_to_bone
				closest_bone = bone
	
	current_bone = closest_bone
	dist_to_current_bone = shortest_dist


func set_current_bone(new_current_bone) -> void:
	if (current_bone == new_current_bone):
		return
	if (current_bone is Bone):
		current_bone.status = Bone.Status.FREE
	if (new_current_bone is Bone):
		new_current_bone.status = Bone.Status.TUGGED
	current_bone = new_current_bone


func find_and_tug_target() -> void:
	find_closest_bone()
	move_bone()
	

func move_bone() -> void:
	if (current_bone is not Bone || status == Status.IDLE || dist_to_current_bone > Global.tug_range):
		tug_rope.disable()
		return
	else:
		tug_rope.enable()
	
	var new_force: Vector2 = current_bone.global_position.direction_to(global_position) * calculate_tugging_power()
	var weight: float = dist_to_current_bone / Global.tug_range
	match status:
		Status.SNAPPING:
			force_applied = -(new_force * calculate_snap_multiplier())
		Status.TUGGING:
			force_applied = force_applied.lerp(new_force, weight)
	current_bone.apply_force(force_applied)


func calculate_snap_multiplier() -> float:
	return (max_snap_multiplier * ((snap_timer.wait_time - snap_timer.time_left) / snap_timer.wait_time))


func snap_away() -> void:
	move_bone()
	status = Status.IDLE


func calculate_tugging_power() -> float:
	if (dist_to_current_bone >= Global.tug_range):
		return 0
	var tugging_power = Global.tug_power * calculate_exponential_multiplier()

	return [tugging_power, 100].max()

# Tugging power and tug_rope width drop off exponentially
func calculate_exponential_multiplier() -> float:
	var number_of_tuggers = get_tree().get_nodes_in_group('tugging_keys').size()
	var number_of_tuggers_ratio = (max_tuggers - number_of_tuggers) / max_tuggers

	var power_multiplier = (dist_to_current_bone / Global.tug_range)
	return exp(-tug_decay * power_multiplier) * number_of_tuggers_ratio


func _physics_process(_delta: float) -> void:
	match status:
		Status.TUGGING:
			find_and_tug_target()
		Status.SNAPPING:
			snap_away()
