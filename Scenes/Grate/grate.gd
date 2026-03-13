extends Node2D

@onready var grate_audio_player: AudioStreamPlayer2D = %GrateAudioPlayer

@export var activated: bool = true:
	set(value):
		activated = value
		if grate_audio_player:
			grate_audio_player.playing = activated

func _ready():
	grate_audio_player.playing = activated
