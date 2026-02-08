extends Node2D

@onready var blob_sounds: Node2D = %BlobSounds


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.audio_manager = self
	

func play_blob_sound(sound_type):
	print(sound_type)
	var player = blob_sounds.get_player()
	if player == null:
		return
	var random_index = randi() % blob_sounds.get(sound_type).size()
	player.stream = blob_sounds.get(sound_type)[random_index]
	player.play()
