extends Node2D

@export var chime: Array[AudioStream] = []
@export var fire: Array[AudioStream] = []
@export var water: Array[AudioStream] = []

@onready var player: AudioStreamPlayer2D = %GeneralSoundPlayer

func get_player():
	var available_player = null
	if !player.playing:
		available_player = player
	return available_player