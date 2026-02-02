@tool
class_name Screen
extends Node2D

@onready var screen_space: Area2D = %ScreenSpace
@onready var screen_collision_shape: CollisionShape2D = %ScreenCollisionShape
@onready var screen_full_keeb: FullKeeb = %ScreenFullKeeb
@onready var screen_anchor: Marker2D = %ScreenAnchor

@export var parent_level : LevelScript
@export var x_coordinate : int
@export var y_coordinate : int

@export var snap_screen_to_position: bool = false:
	set(value):
		snap_screen_to_position = value
		if snap_screen_to_position and Engine.is_editor_hint():
			set_screen_position()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('screens')
	set_screen_position()
	screen_full_keeb.process_mode = Node.PROCESS_MODE_DISABLED
	screen_full_keeb.visible = false


func set_screen_position():
	if x_coordinate is int && y_coordinate is int:
		global_position = Vector2(1920 * x_coordinate, 1080 * y_coordinate)
