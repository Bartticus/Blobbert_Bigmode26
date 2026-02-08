extends Node2D

@export var siren: Array[AudioStream] = []
@export var explosion: Array[AudioStream] = []

@onready var player: AudioStreamPlayer2D = %RequiredSoundPlayer

func get_player():
	var available_player = null
	if !player.playing:
		available_player = player
	return available_player