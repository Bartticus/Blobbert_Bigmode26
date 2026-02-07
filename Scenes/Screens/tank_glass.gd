extends Node2D

@export var groups_broken: int = 0
@export var required_groups: int = 10
@export var triggerable_objects: Array[Node2D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for gp in get_children():
		gp.tank_glass = self

func iterate_groups_broken():
	groups_broken += 1
	if groups_broken >= required_groups:
		print(groups_broken)
		print(required_groups)
		tank_broken()

func tank_broken():
	for io in triggerable_objects:
		io.trigger_action()
