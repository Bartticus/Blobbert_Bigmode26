@tool
extends Node2D

@onready var sfx_bus_index: int = AudioServer.get_bus_index('SFX')
@onready var zone_collision_shape: CollisionShape2D = %ZoneCollisionShape

@export var crank_it: bool = false
@export var audio_effect: AudioEffect
@export var zone_shape: Shape2D:
	set(value):
		zone_shape = value
		if zone_collision_shape:
			zone_collision_shape.shape = zone_shape

func _ready() -> void:
	zone_collision_shape.shape = zone_shape

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == 'BlobLevelTransitionArea':
		AudioServer.add_bus_effect(sfx_bus_index, audio_effect)
		if crank_it:
			Global.sound_manager.ambient_sounds.player.volume_db = 6.0
			Global.sound_manager.ambient_sounds.player.pitch_scale = 0.9


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == 'BlobLevelTransitionArea':
		AudioServer.remove_bus_effect(sfx_bus_index, 0)
		if crank_it:
			Global.sound_manager.ambient_sounds.player.volume_db = 0.0
			Global.sound_manager.ambient_sounds.player.pitch_scale = 1.0
