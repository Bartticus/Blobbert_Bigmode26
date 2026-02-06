class_name Beaker
extends RigidBody2D

@export var flammable: bool = false
@export var exploding: bool = false
@export var sprite_scale_mult: float = 0.05
@export var objects_to_explode: Array[Node2D] = []

@onready var beaker_sprite: Sprite2D = %BeakerSprite
@onready var explosion_timer: Timer = %ExplosionTimer
@onready var beaker_polygon: CollisionPolygon2D = %BeakerPolygon


func _on_flame_check_area_entered(area: Area2D) -> void:
	if area.name == 'AdjacentOilChecker':
		if area.owner.ignited && flammable:
			explode()


func explode():
	if exploding || !flammable:
		return
	exploding = true
	explosion_timer.start()

func _physics_process(delta: float) -> void:
	if exploding:
		var sprite_scale = sprite_scale_mult * delta
		beaker_sprite.scale += Vector2(sprite_scale, sprite_scale)
		beaker_polygon.scale += Vector2(sprite_scale, sprite_scale)



func _on_explosion_timer_timeout() -> void:
	exploding = false
	for o in objects_to_explode:
		o.trigger_action()
	queue_free()
