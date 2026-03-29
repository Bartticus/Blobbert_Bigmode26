class_name Fire
extends Node2D

@export var enable_on_floor_enter: bool = false

@onready var fire_sprite: Sprite2D = %FireSprite
@onready var fire_animation: AnimationPlayer = %FireAnimation
@onready var fire_sound_area: Area2D = %FireSoundArea
@onready var fire_sound_player: SoundPlayer = %FireSoundPlayer

func _ready():
	if visible:
		enable_on_floor_enter = true
		fire_sound_area.process_mode = PROCESS_MODE_INHERIT

func activate():
	show()
	enable_on_floor_enter = true
	fire_sound_area.process_mode = PROCESS_MODE_INHERIT
	fire_animation.play('burn')

func deactivate():
	hide()
	fire_sound_area.process_mode = PROCESS_MODE_DISABLED
