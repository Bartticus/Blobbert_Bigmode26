class_name AmbientSounds
extends Node2D

@export var vents: AudioStream
@export var lab: AudioStream
@export var tank: AudioStream
@export var bunsen: AudioStream
@export var crackling: AudioStream

@onready var player_1: AudioStreamPlayer = %AmbientSoundPlayer1
@onready var player_2: AudioStreamPlayer = %AmbientSoundPlayer2

var player: AudioStreamPlayer


func get_player():
	var available_player = null
	for _player in [player_1, player_2]:
		if !_player.playing:
			available_player = _player
			player = _player
	return available_player

func crank_it():
	player.volume_db = 1.8
	player.pitch_scale = 1.4

func ramp_it(amount):
	player.volume_db += amount
	if player.volume_db <= 0:
		player.stop()
