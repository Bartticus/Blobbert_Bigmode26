class_name SoundPlayer
extends Node2D

@export var sound_files: Array[AudioStream] = []
@export var random_pitch: bool = false
@export var interruptable: bool = false
@export var max_distance: float = 3000.0
@export var attenuation: float = 0.5
@export var volume_db: float = 0.0
@export var autoplay: bool = false


@onready var player: AudioStreamPlayer2D = %StreamPlayer

func _ready():
	player.max_distance = max_distance
	player.attenuation = attenuation
	if autoplay:
		play_sound()

func play_sound(pitch_scale: float = 1.0, added_db: float = volume_db):
	if player.playing && !interruptable:
		return
	player.stream = sound_files.pick_random()
	player.pitch_scale = pitch_scale
	player.volume_db = added_db
	shift_pitch()
	player.play()
	return player

func shift_pitch():
	if random_pitch:
		player.pitch_scale += randf_range(-0.2, 0.2)
