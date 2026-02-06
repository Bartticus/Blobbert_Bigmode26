class_name NewGlassPanes
extends Node2D

@onready var thick_wall_shape: CollisionShape2D = %ThickWallShape

@export var all_glass_panes: Array[GreasableObject] = []
@export var thick_wall: StaticBody2D
@export var thick_wall_dimensions: Vector2 = Vector2(286, 954)
@export var destroy_all_at_once: bool = true
@export var unbreakable: bool = false
@export var all_destroyed: bool = false
@export var tank_glass: Node2D = null

@export var anim_player: AnimationPlayer


func set_wall_thickness():
	thick_wall_shape.shape.size = thick_wall_dimensions
	thick_wall.position = thick_wall_dimensions / 2

func _ready() -> void:
	for child in get_children():
		if child is GreasableObject:
			if unbreakable:
				child.glass_pane = false
			all_glass_panes.append(child)
			child.connect("tree_exiting", _on_pane_exiting.bind(child))
		if child is StaticBody2D:
			thick_wall = child
	set_wall_thickness()

func _on_pane_exiting(_pane: GreasableObject) -> void:
	if thick_wall:
		thick_wall.queue_free()
	
	if destroy_all_at_once:
		for pane in all_glass_panes:
			if pane:
				pane.queue_free()
		all_destroyed = true
		if tank_glass:
			tank_glass.iterate_groups_broken()
		
	if anim_player:
		anim_player.play("breach")
