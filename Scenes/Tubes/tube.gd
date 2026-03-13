extends RigidBody2D

@onready var tube_sound_player: SoundPlayer = %TubeSoundPlayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Bone:
		tube_sound_player.play_sound()


func _on_tube_area_area_entered(area: Area2D) -> void:
	if area.name == 'TubeArea':
		tube_sound_player.play_sound()
