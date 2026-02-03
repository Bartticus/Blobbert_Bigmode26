extends Node2D

@export var left_glass_panes: Array[GreasableObject]
@export var right_glass_panes: Array[GreasableObject]

@export var left_thick_wall: StaticBody2D
@export var right_thick_wall: StaticBody2D

func _ready() -> void:
	for pane in left_glass_panes:
		pane.connect("tree_exiting", _on_left_pane_exiting.bind(pane))
	for pane in right_glass_panes:
		pane.connect("tree_exiting", _on_right_pane_exiting.bind(pane))

func _on_left_pane_exiting(_pane: GreasableObject) -> void:
	if left_thick_wall:
		left_thick_wall.queue_free()
	
	for pane in left_glass_panes:
		if pane:
			pane.queue_free()

func _on_right_pane_exiting(_pane: GreasableObject) -> void:
	if right_thick_wall:
		right_thick_wall.queue_free()
	
	for pane in right_glass_panes:
		if pane:
			pane.queue_free()
