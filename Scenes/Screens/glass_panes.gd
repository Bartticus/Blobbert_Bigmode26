extends Node2D

@export var left_glass_panes: Array[GreasableObject]
@export var right_glass_panes: Array[GreasableObject]

@export var left_thick_wall: StaticBody2D
@export var right_thick_wall: StaticBody2D

func _ready() -> void:
	for pane in left_glass_panes:
		pane.connect("tree_exiting", remove_left_wall)
	for pane in right_glass_panes:
		pane.connect("tree_exiting", remove_right_wall)

func remove_left_wall() -> void:
	if left_thick_wall:
		left_thick_wall.queue_free()

func remove_right_wall() -> void:
	if right_thick_wall:
		right_thick_wall.queue_free()
