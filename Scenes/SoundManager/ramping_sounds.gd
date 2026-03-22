class_name RampingSounds
extends Node2D


@export var starting_db: float = -20.0
@export var crackling: AudioStream
@export var sources_in_proximity: int = 0:
	set(value):
		sources_in_proximity = value
		if sources_in_proximity >= 1:
			if !player.playing:
				Global.sound_manager.play_ramping_sound("crackling")
			ramp_it([((starting_db - 1) + (sources_in_proximity * 0.7)), -4.0].min())
		else:
			player.stop()

@onready var player: AudioStreamPlayer = %RampingSoundPlayer

func ramp_it(amount):
	if player:
		player.volume_db = amount