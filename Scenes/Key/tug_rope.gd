extends Line2D

@onready var beam: ColorRect = %Beam

@export var min_thickness: float = 0.03
@export var max_thickness: float = 0.07
@export var min_outline_thickness: float = 0.1
@export var max_outline_thickness: float = 0.2
@export var min_noise_scale_x: float = 1.0

@export var min_beam_alpha: float = 0.2
@export var max_beam_alpha: float = 0.9
@export var default_beam_color: Vector4 = Vector4(0.91, 1.0, 1.0, max_beam_alpha)

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
	beam.material.set_shader_parameter('noise_scale', Vector2([(length / 100), min_noise_scale_x].max(), 1.0))

	var new_beam_color = default_beam_color
	new_beam_color[3] = [(exponential_multiplier * max_beam_alpha), min_beam_alpha].max()
	beam.material.set_shader_parameter('color', new_beam_color)

func _physics_process(_delta: float) -> void:
	if (visible && parent_key.current_bone):
		draw_line_to_bone()

func enable() -> void:
	beam.visible = true
	
func disable() -> void:
	target_position = null
	beam.visible = false
