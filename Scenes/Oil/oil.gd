class_name Oil
extends Area2D

@onready var splatter_sprites: AnimatedSprite2D = $Splatters
@onready var fire: Node2D = $Fire
@onready var adj_oil_checker: Area2D = $AdjacentOilChecker
@onready var ignited: bool = false

@onready var particles: CPUParticles2D = $CPUParticles2D

var camera: Camera2D
var camera_shake_noise: FastNoiseLite

func _ready() -> void:
	splatter_sprites.frame = randi_range(0,3)
	
	particles.emitting = true
	particles.scale_amount_max *= scale.length()
	
	start_camera_shake()

func start_camera_shake():
	var intensity = scale.length_squared()
	if intensity < 1: return
	
	camera = get_viewport().get_camera_2d()
	camera_shake_noise = FastNoiseLite.new()
	
	var camera_tween: Tween = get_tree().create_tween()
	camera_tween.tween_method(camera_shake_value, intensity, 0, 0.2)

func camera_shake_value(intensity: float):
	var camera_offset: float = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera.offset.x = camera_offset
	camera.offset.y = camera_offset

func _on_ignition_timer_timeout() -> void:
	for area in adj_oil_checker.get_overlapping_areas():
		if area.owner is Oil:
			var oil = area.owner
			if oil.fire.visible:
				ignite()
		if area.owner is Beaker && ignited:
			area.owner.explode()

func ignite() -> void:
	if ignited: return
	
	ignited = true
	fire.show()
	fire.fire_animation.play('burn')
	Global.sound_manager.play_general_sound('fire', [(1 / scale.length()), 0.6].max(), scale.length_squared() - 5)
	
	Global.sound_manager.play_ambient_sound("crackling")
	Global.sound_manager.ambient_sounds.ramp_it(scale.length() / 4.0)

func _on_body_entered(body: Node2D) -> void:
	if body is Bone:
		body.oil_areas_int += 1
		body.current_oil_overlap.append(self)

func _on_body_exited(body: Node2D) -> void:
	if body is Bone:
		body.oil_areas_int -= 1
		body.current_oil_overlap.erase(self)

var prev_dist: float = 0
func _on_dist_check_timer_timeout() -> void:
	var dist_to_player: float = global_position.distance_to(Global.blob.center_bone.global_position)
	var sfx_cutoff = 1000
	if dist_to_player < sfx_cutoff && prev_dist > sfx_cutoff: #Increase sound when entering range
		Global.sound_manager.ambient_sounds.ramp_it(scale.length() / 4.0)
	if dist_to_player > sfx_cutoff && prev_dist < sfx_cutoff: #Reduce sound when leaving range
		Global.sound_manager.ambient_sounds.ramp_it(-scale.length() / 4.0)
	
	
	prev_dist = dist_to_player
