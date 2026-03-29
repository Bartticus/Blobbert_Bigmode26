extends Node2D

@onready var grate_audio_player: AudioStreamPlayer2D = %GrateAudioPlayer
@onready var grate_sound_player: SoundPlayer = %GrateSoundPlayer

@export var activated: bool = true:
	set(value):
		activated = value
		if grate_sound_player:
			if activated:
				grate_sound_player.play_sound()
			else:
				grate_sound_player.stop_sound()
