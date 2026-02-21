extends Node2D

@export var chime: Array[AudioStream] = []

@onready var player_1: AudioStreamPlayer2D = %StackingSoundPlayer1
@onready var player_2: AudioStreamPlayer2D = %StackingSoundPlayer2
@onready var player_3: AudioStreamPlayer2D = %StackingSoundPlayer3
@onready var player_4: AudioStreamPlayer2D = %StackingSoundPlayer4

func get_player():
	var available_player = null
	for player in [player_1, player_2, player_3, player_4]:
		if !player.playing:
			available_player = player
	return available_player