class_name RequiredSounds
extends Node2D

@export var glass_break: Array[AudioStream] = []
@export var siren: Array[AudioStream] = []
@export var explosion: Array[AudioStream] = []
@export var sizzle: Array[AudioStream] = []

@onready var player_1: AudioStreamPlayer = %RequiredSoundPlayer1
@onready var player_2: AudioStreamPlayer = %RequiredSoundPlayer2

func get_player():
	var available_player = null
	for player in [player_1, player_2]:
		if !player.playing:
			available_player = player
	return available_player
