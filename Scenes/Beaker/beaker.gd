class_name Beaker
extends RigidBody2D

@export var flammable: bool = false
@export var exploding: bool = false
@export var sprite_scale_mult: float = 0.05
@export var objects_to_explode: Array[Node2D] = []
@export var pin_joint: PinJoint2D = null
@export var top_blocker: StaticBody2D = null
@export var center_mass_type: CenterOfMassMode = CENTER_OF_MASS_MODE_AUTO:
	set(value):
		center_mass_type = value
		center_of_mass_mode = center_mass_type	

@onready var explosion_timer: Timer = %ExplosionTimer
@onready var beaker_collision_polygon: CollisionPolygon2D = %BeakerCollisionPolygon
@onready var explosion_anim: AnimationPlayer = %AnimationPlayer
@onready var fire: Node2D = %Fire
@onready var oil_parent: Polygon2D = %OilParent
@onready var reaction_sound_player: SoundPlayer = %ReactionSoundPlayer
@onready var explosion_sound_player: SoundPlayer = %ExplosionSoundPlayer

var reaction_player: AudioStreamPlayer2D = null


func _on_flame_check_area_entered(area: Area2D) -> void:
	if area.name == 'AdjacentOilChecker':
		if area.owner.ignited && flammable:
			explode()


func explode():
	if exploding || !flammable:
		return
	exploding = true
	fire.visible = true
	reaction_player = reaction_sound_player.play_sound()
	explosion_timer.start()

func _physics_process(delta: float) -> void:
	if exploding && is_instance_valid(oil_parent) && is_instance_valid(beaker_collision_polygon):
		var sprite_scale = sprite_scale_mult * delta
		oil_parent.scale += Vector2(sprite_scale, sprite_scale)
		beaker_collision_polygon.scale += Vector2(sprite_scale, sprite_scale)
	if rotation_degrees > 27.0:
		center_of_mass_mode = CENTER_OF_MASS_MODE_AUTO
		if pin_joint:
			pin_joint.queue_free()
		if top_blocker:
			top_blocker.queue_free()

func _on_explosion_timer_timeout() -> void:
	for o in objects_to_explode:
		if o:
			o.trigger_action()
	
	#make beaker and oils invisible
	oil_parent.queue_free()
	beaker_collision_polygon.queue_free()
	var all_children = get_all_children(self)
	for child in all_children:
		if child is Oil:
			child.hide()
	
	reaction_player.stop()
	explosion_sound_player.play_sound()
	explosion_anim.play("boom")
	await explosion_anim.animation_finished
	
	queue_free()

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr
