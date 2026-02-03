extends Node2D

@onready var target_position: Marker2D = %TargetPosition
@onready var door_body: AnimatableBody2D = %DoorBody

@export var move_door: bool = false
@export var move_time: float = 2.0


func trigger_action() -> void:
	move_door = true

func _physics_process(delta: float) -> void:
	if move_door:
		tween_door()
		move_door = false

func tween_door() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(door_body, 'global_position', target_position.global_position, move_time)
