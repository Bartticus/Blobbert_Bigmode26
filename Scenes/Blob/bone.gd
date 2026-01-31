class_name Bone
extends RigidBody2D

enum Status { FREE, TUGGED, PINCHED }
# Every time the 'status' is set, set_status will run and perform any side effects for the new status
@export var status: Status = Status.FREE : set = set_status

func set_status(new_status) -> void:
	status = new_status
	# match status:
	# 	pass