extends AudioStreamPlayer

@export var next_song: AudioStream


func _on_finished() -> void:
	stream = next_song
	play()
