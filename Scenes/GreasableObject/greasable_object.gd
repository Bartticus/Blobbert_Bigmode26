extends Node2D

@export var stain_sprite: Sprite2D


var max_grease: float = 2000000
var grease_level: float = 0
var splatter_speed: float = 0.01

func _on_velocity_detector_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		var relative_pos: Vector2 = (global_position - body.global_position).normalized()
		var velocity: Vector2 = body.linear_velocity
		
		var direction_towards_object: float = relative_pos.dot(velocity)
		var new_strength: float = direction_towards_object * velocity.length() / max_grease
		
		if new_strength > grease_level:
			grease_level = new_strength

func _process(_delta: float) -> void:
	var shader_sens = stain_sprite.material.get_shader_parameter("sensitivity")
	if shader_sens < grease_level:
		stain_sprite.material.set_shader_parameter("sensitivity", shader_sens + splatter_speed)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_CTRL):
		grease_level = 0
		stain_sprite.material.set_shader_parameter("sensitivity", 0)
