extends Node2D

@onready var anim_player: AnimationPlayer = %BreachAnimationPlayer
@onready var breach_sound_player: SoundPlayer = %BreachSoundPlayer

func play_breach():
	anim_player.play('breach')
	breach_sound_player.play_sound()
