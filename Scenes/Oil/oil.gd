class_name Oil
extends Area2D

@onready var splatter_sprites: AnimatedSprite2D = $Splatters
@onready var fire_sprite: Sprite2D = $Fire
@onready var adj_oil_checker: Area2D = $AdjacentOilChecker
@onready var ignited: bool = false

var camera: Camera2D
var camera_shake_noise: FastNoiseLite

func _ready() -> void:
	splatter_sprites.frame = randi_range(0,3)
	
	start_camera_shake()

func start_camera_shake():
	var intensity = scale.length_squared()
	if intensity < 1: return
	
	camera = get_viewport().get_camera_2d()
	camera_shake_noise = FastNoiseLite.new()
	
	var camera_tween: Tween = get_tree().create_tween()
	camera_tween.tween_method(camera_shake_value, intensity, 0, 0.1)

func camera_shake_value(intensity: float):
	var camera_offset: float = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera.offset.x = camera_offset
	camera.offset.y = camera_offset

func _on_timer_timeout() -> void:
	for area in adj_oil_checker.get_overlapping_areas():
		if area.owner is Oil:
			var oil = area.owner
			if oil.fire_sprite.visible:
				ignite()
		if area.owner is Beaker && ignited:
			area.owner.explode()

func ignite() -> void:
	ignited = true
	fire_sprite.show()

func _on_body_entered(body: Node2D) -> void:
	if body is Bone:
		body.oil_areas_int += 1

func _on_body_exited(body: Node2D) -> void:
	if body is Bone:
		body.oil_areas_int -= 1
