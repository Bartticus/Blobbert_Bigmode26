class_name Bone
extends RigidBody2D

enum Status { FREE, TUGGED, PINCHED }
# Every time the 'status' is set, set_status will run and perform any side effects for the new status
@export var status: Status = Status.FREE : set = set_status
@export var total_wind_forces: float = 0.0

@export var in_oil_area: bool = false
@export var oil_areas_int: int = 0:
	set(value):
		oil_areas_int = value
		if oil_areas_int > 0:
			in_oil_area = true
		else:
			in_oil_area = false


func set_status(new_status) -> void:
	status = new_status
	# match status:
	# 	pass

func return_home():
	var should_return = false
	for body in get_colliding_bodies():
		if !(body is Bone):
			should_return = true
			break
	if should_return:
		set_collision_mask_value(1, false)
		await get_tree().create_timer(0.1).timeout
		set_collision_mask_value(1, true)

