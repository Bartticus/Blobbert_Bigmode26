extends Node2D

@onready var blob_sounds: Node2D = %BlobSounds
@onready var general_sounds: Node2D = %GeneralSounds
@onready var required_sounds: Node2D = %RequiredSounds
@onready var stacking_sounds: Node2D = %StackingSounds


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.sound_manager = self
	

func play_blob_sound(sound_type):
	var player = blob_sounds.get_player()
	if player == null:
		return
	var random_index = randi() % blob_sounds.get(sound_type).size()
	player.stream = blob_sounds.get(sound_type)[random_index]
	player.play()

func play_general_sound(sound_type):
	var player = general_sounds.get_player()
	if player == null:
		return
	var random_index = randi() % general_sounds.get(sound_type).size()
	player.stream = general_sounds.get(sound_type)[random_index]
	player.play()

func play_required_sound(sound_type):
	var player = required_sounds.get_player()
	if player == null:
		return
	var random_index = randi() % required_sounds.get(sound_type).size()
	player.stream = required_sounds.get(sound_type)[random_index]
	player.play()

func play_stacking_sound(sound_type):
	var player = stacking_sounds.get_player()
	if player == null:
		return
	var random_index = randi() % stacking_sounds.get(sound_type).size()
	player.stream = stacking_sounds.get(sound_type)[random_index]
	player.play()

