extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var fan_sound_player: SoundPlayer = %FanSoundPlayer

@export var fan_speed: float = 1.0:
	set(value):
		fan_speed = value
		if animation_player:
			animation_player.speed_scale = fan_speed
@export var enabled: bool = true:
	set(value):
		enabled = value
		if animation_player:
			animation_player.active = enabled




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.speed_scale = fan_speed
	animation_player.active = enabled


func trigger_action():
	fan_speed = 3.0
	fan_sound_player.play_sound()
