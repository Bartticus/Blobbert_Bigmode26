extends Node2D

@onready var min_load: Timer = %MinLoad

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Fade.fade_in(0.5)
	Global.load_next_scene()
	
