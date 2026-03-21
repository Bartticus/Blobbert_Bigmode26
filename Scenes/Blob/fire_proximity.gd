class_name FireProximity
extends Node2D

@onready var fire_proximity_area: Area2D = %FireProximityArea
@onready var fire_proximity_shape: CollisionShape2D = %FireProximityShape
@onready var capsule_shape: CapsuleShape2D = preload('uid://bgdvpd6r33wra')
@onready var circle_shape: CircleShape2D = preload('uid://tkt6u21q8tv7')

func set_capsule_shape():
	fire_proximity_shape.shape = capsule_shape

func set_circle_shape():
	fire_proximity_shape.shape = circle_shape

func _on_fire_proximity_area_area_exited(area: Area2D) -> void:
	if area.name == 'FireSoundArea':
		Global.sound_manager.ramping_sounds.sources_in_proximity -= 1

func _on_fire_proximity_area_area_entered(area: Area2D) -> void:
	if area.name == 'FireSoundArea':
		Global.sound_manager.ramping_sounds.sources_in_proximity += 1
