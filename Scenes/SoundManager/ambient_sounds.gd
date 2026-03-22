class_name AmbientSounds
extends Node2D

@export var vents: AudioStream
@export var lab: AudioStream
@export var tank: AudioStream
@export var bunsen: AudioStream

@onready var player: AudioStreamPlayer = %AmbientSoundPlayer

func crank_it():
	player.volume_db = 1.8
	player.pitch_scale = 1.4
