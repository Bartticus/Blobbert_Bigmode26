class_name Oil
extends Area2D

@onready var splatter_sprite: Sprite2D = $Splatter
@onready var fire_sprite: Sprite2D = $Fire


func _on_timer_timeout() -> void:
	for area in get_overlapping_areas():
		if area is Oil:
			if area.fire_sprite.visible:
				ignite()

func ignite() -> void:
	fire_sprite.show()

func _on_body_entered(body: Node2D) -> void:
	if body is Bone:
		body.oil_areas_int += 1

func _on_body_exited(body: Node2D) -> void:
	if body is Bone:
		body.oil_areas_int -= 1
