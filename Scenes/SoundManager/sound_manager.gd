class_name SoundManager
extends Node2D

@onready var blob_sounds: Node2D:
	get:
		return Global.blob.blob_sounds
		
@onready var general_sounds: GeneralSounds = %GeneralSounds
@onready var required_sounds: RequiredSounds = %RequiredSounds
@onready var ambient_sounds: AmbientSounds = %AmbientSounds

var KEEP_PITCH = ['glass_break', 'siren', 'sizzle', 'explosion', 'chime']


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.sound_manager = self
	

func play_blob_sound(sound_type):
	var player = blob_sounds.get_player()
	if player == null:
		return
	var random_index = randi() % blob_sounds.get(sound_type).size()
	player.stream = blob_sounds.get(sound_type)[random_index]
	
	player.pitch_scale = 1.0
	shift_pitch(sound_type, player)
	player.play()
	return player

func play_general_sound(sound_type, pitch_scale: float = 1.0, added_db: float = 0.0):
	var player = general_sounds.get_player()
	if player == null:
		return
	var random_index = randi() % general_sounds.get(sound_type).size()
	player.stream = general_sounds.get(sound_type)[random_index]
	#Fire sounds scale with their size
	player.pitch_scale = pitch_scale
	player.volume_db = added_db
	
	shift_pitch(sound_type, player)
	player.play()
	return player

func play_required_sound(sound_type):
	var player = required_sounds.get_player()
	if player == null:
		return
	var random_index = randi() % required_sounds.get(sound_type).size()
	player.stream = required_sounds.get(sound_type)[random_index]
	
	player.pitch_scale = 1.0
	shift_pitch(sound_type, player)
	player.play()
	return player

func play_ambient_sound(sound_type):
	var player = ambient_sounds.get_player()
	if player == null:
		return
	player.stream = ambient_sounds.get(sound_type)
	player.play()
	return player


func shift_pitch(sound_type, player):
	if !KEEP_PITCH.has(sound_type):
		player.pitch_scale += randf_range(-0.2, 0.2)
