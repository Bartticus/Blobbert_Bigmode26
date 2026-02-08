extends Node2D

@export var stretch: Array[AudioStream] = []
@export var squish: Array[AudioStream] = []
@export var whoosh: Array[AudioStream] = []
@export var bounce: Array[AudioStream] = []
@export var fling: Array[AudioStream] = []

@onready var player_1: AudioStreamPlayer2D = %Player1
@onready var player_2: AudioStreamPlayer2D = %Player2
@onready var player_3: AudioStreamPlayer2D = %Player3


func get_player():
	var available_player = null
	for player in [player_1, player_2, player_3]:
		if !player.playing:
			available_player = player
	return available_player