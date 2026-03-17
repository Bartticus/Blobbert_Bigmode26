class_name BunsenBurner
extends Node2D

@onready var fire_sprites: AnimatedSprite2D = $FireSprites
@onready var fire_light: PointLight2D = $FireLight
var light_init_scale: Vector2


func _ready() -> void:
	light_init_scale = fire_light.scale

func _on_fire_sprites_frame_changed() -> void:
	if fire_sprites.frame == 0:
		fire_light.scale = light_init_scale
	else:
		fire_light.scale = light_init_scale * 1.1

func _on_fire_detection_area_entered(area: Area2D) -> void:
	if area.name == 'AdjacentOilChecker':
		if !area.owner.ignited:
			area.owner.ignite()
