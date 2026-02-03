extends Node2D

@export var wind_power: float = 80.0
@export var active: bool = true

@onready var start_location: Vector2 = %StartLocation.global_position
@onready var end_location: Vector2 = %EndLocation.global_position
@onready var wind_area: Area2D = %WindArea
@onready var arrow: Polygon2D = %Arrow


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrow.visible = false
	visible = active

func _physics_process(_delta: float) -> void:
	if !active:
		return
	var power = start_location.direction_to(end_location) * wind_power
	for body in wind_area.get_overlapping_bodies():
		if body is Bone:
			body.apply_force(power / body.total_wind_forces)


func _on_wind_area_body_entered(body: Node2D) -> void:
	if body is Bone:
		body.total_wind_forces += 1


func _on_wind_area_body_exited(body: Node2D) -> void:
	if body is Bone:
		body.total_wind_forces -= 1

func trigger_action() -> void:
	active = !active
	visible = active
