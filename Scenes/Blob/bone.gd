class_name Bone
extends RigidBody2D

enum Status { FREE, TUGGED, PINCHED }
# Every time the 'status' is set, set_status will run and perform any side effects for the new status
@export var status: Status = Status.FREE : set = set_status
@export var total_wind_forces: float = 0.0

@export var in_oil_area: bool = false
@export var oil_areas_int: int = false:
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

#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#var state = PhysicsServer2D.body_get_direct_state(get_rid())
	#var normal = state.get_contact_local_normal(i)
