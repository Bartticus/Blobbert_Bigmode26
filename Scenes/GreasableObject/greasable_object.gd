class_name GreasableObject
extends Node2D

@export var destroy_on_greased: bool = true
@export var triggerable_objects: Array[Node2D] = []
@export var stain_sprite: Sprite2D
@export var grease_level: float = 0
@export var glass_pane: bool

@export var anim_player: AnimationPlayer

var max_grease: float = 1000
var splatter_speed: float = 0.05

@onready var ungrease_timer: Timer = $UngreasableTimer


func _on_velocity_detector_body_entered(body: Node2D) -> void:
	if not ungrease_timer.is_stopped(): return
	if grease_level > 1.0:
		return
	
	if body is RigidBody2D:
		var velocity: Vector2 = body.linear_velocity
		var new_strength: float = velocity.length() / max_grease
		
		var one_half: float = 1.0 / 2.0
		if new_strength > one_half and grease_level < one_half:
			ungrease_timer.start()
		if new_strength > (2 * one_half) and grease_level < (2 * one_half):
			ungrease_timer.start()
			
		if new_strength > grease_level + one_half: #Requires at least 3 hits
			grease_level = grease_level + one_half
			ungrease_timer.start()
		elif new_strength > grease_level:
			grease_level = new_strength
		
		if grease_level > 1.0:
			for trigger in triggerable_objects:
				trigger.trigger_action()
			
			if anim_player:
				anim_player.play("spin")
		
		if glass_pane && grease_level > 1.0:
			queue_free()

func _process(_delta: float) -> void:
	var shader_sens = stain_sprite.material.get_shader_parameter("sensitivity")
	if shader_sens < grease_level:
		stain_sprite.material.set_shader_parameter("sensitivity", shader_sens + splatter_speed)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_CTRL):
		grease_level = 0
		stain_sprite.material.set_shader_parameter("sensitivity", 0)

func trigger_action():
	queue_free()
