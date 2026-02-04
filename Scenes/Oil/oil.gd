class_name Oil
extends Area2D

@onready var splatter_sprites: AnimatedSprite2D = $SplatterClipMask/Splatters
@onready var fire_sprite: Sprite2D = $Fire
@onready var adj_oil_checker: Area2D = $AdjacentOilChecker


func _ready() -> void:
	splatter_sprites.frame = randi_range(0,2)

func _on_timer_timeout() -> void:
	for area in adj_oil_checker.get_overlapping_areas():
		if area.owner is Oil:
			var oil = area.owner
			if oil.fire_sprite.visible:
				ignite()

func ignite() -> void:
	fire_sprite.show()

func _on_body_entered(body: Node2D) -> void:
	if body is Bone:
		body.oil_areas_int += 1

func _on_body_exited(body: Node2D) -> void:
	if body is Bone:
		body.oil_areas_int -= 1
