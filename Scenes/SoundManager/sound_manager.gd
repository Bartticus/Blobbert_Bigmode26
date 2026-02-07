extends Node2D

@onready var blob_audio_player: AudioStreamPlayer2D = %BlobAudioPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.audio_manager = self
