extends Line2D

@onready var beam: ColorRect = %Beam

@export var min_thickness: float = 0.01
@export var max_thickness: float = 0.03
@export var min_outline_thickness: float = 0.03
@export var max_outline_thickness: float = 0.15

var parent_key: Key
var target_position = null

func _ready() -> void:
	disable()

func draw_line_to_bone() -> void:
	var new_target = to_local(parent_key.current_bone.global_position)
	if target_position is Vector2:
		target_position = target_position.lerp(new_target, 0.5)
	else:
		target_position = new_target

	points = [
		position,
		target_position
	]

	var new_rotation = points[0].angle_to_point(points[1])


	var length = points[0].distance_to(points[1])
	beam.rotation = new_rotation
	beam.size.x = length
	var exponential_multiplier = parent_key.calculate_exponential_multiplier()
	var new_thickness = [(max_thickness * exponential_multiplier), min_thickness].max()
	var new_outline_thickness = [(max_outline_thickness * exponential_multiplier), min_outline_thickness].max()
	beam.material.set_shader_parameter('thickness', new_thickness)
	beam.material.set_shader_parameter('outline_thickness', new_outline_thickness)
	# width = [(max_width * parent_key.calculate_exponential_multiplier()), min_width].max()

func _physics_process(_delta: float) -> void:
	if (visible && parent_key.current_bone):
		draw_line_to_bone()

func enable() -> void:
	visible = true
	
func disable() -> void:
	visible = false
	target_position = null
