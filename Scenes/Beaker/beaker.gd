class_name Beaker
extends RigidBody2D

@export var flammable: bool = false
@export var exploding: bool = false
@export var sprite_scale_mult: float = 0.05
@export var objects_to_explode: Array[Node2D] = []

@onready var beaker_sprite: Sprite2D = %BeakerSprite
@onready var explosion_timer: Timer = %ExplosionTimer
@onready var beaker_polygon: CollisionPolygon2D = %BeakerPolygon
@onready var explosion_anim: AnimationPlayer = %AnimationPlayer
@onready var fire: Node2D = %Fire

var sizzle_player: AudioStreamPlayer2D = null


func _on_flame_check_area_entered(area: Area2D) -> void:
	if area.name == 'AdjacentOilChecker':
		if area.owner.ignited && flammable:
			explode()


func explode():
	if exploding || !flammable:
		return
	exploding = true
	fire.visible = true
	sizzle_player = Global.sound_manager.play_required_sound('sizzle')
	explosion_timer.start()

func _physics_process(delta: float) -> void:
	if exploding && is_instance_valid(beaker_sprite) && is_instance_valid(beaker_polygon):
		var sprite_scale = sprite_scale_mult * delta
		beaker_sprite.scale += Vector2(sprite_scale, sprite_scale)
		beaker_polygon.scale += Vector2(sprite_scale, sprite_scale)

func _on_explosion_timer_timeout() -> void:
	for o in objects_to_explode:
		if o:
			o.trigger_action()
	
	#make beaker and oils invisible
	beaker_sprite.queue_free()
	beaker_polygon.queue_free()
	var all_children = get_all_children(self)
	for child in all_children:
		if child is Oil:
			child.hide()
	
	sizzle_player.stop()
	Global.sound_manager.play_required_sound('explosion')
	explosion_anim.play("boom")
	await explosion_anim.animation_finished
	
	queue_free()

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr
