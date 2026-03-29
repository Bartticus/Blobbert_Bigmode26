class_name SoundPlayer
extends Node2D

@export var sound_files: Array[AudioStream] = []
@export var random_pitch: bool = false
@export var interruptable: bool = false
@export var max_distance: float = 3000.0
@export var attenuation: float = 1.0
@export var volume_db: float = 0.0
@export var panning_strength: float = 1.0
@export var autoplay: bool = false
@export var fade_in: bool = false

@onready var player: AudioStreamPlayer2D = %StreamPlayer
@onready var interrupt_timer: Timer = %InterruptTimer

func _ready():
	player.max_distance = max_distance
	player.attenuation = attenuation
	player.panning_strength = panning_strength
	if autoplay:
		play_sound()

func play_sound(pitch_scale: float = 1.0, added_db: float = volume_db):
	if player.playing && !interruptable:
		return
	if interruptable && interrupt_timer.time_left > 0:
		if player.playing:
			return
	player.stream = sound_files.pick_random()
	player.pitch_scale = pitch_scale
	if fade_in:
		player.volume_db = -10.0
	else:
		player.volume_db = added_db
	shift_pitch()
	if interruptable:
		interrupt_timer.start()
	player.play()

	if fade_in:
		var tween = create_tween()
		tween.set_ignore_time_scale()
		tween.tween_property(player, 'volume_db', added_db, 0.1)

	return player

func stop_sound():
	if player.playing:
		player.stop()

func shift_pitch():
	if random_pitch:
		player.pitch_scale += randf_range(-0.2, 0.2)
