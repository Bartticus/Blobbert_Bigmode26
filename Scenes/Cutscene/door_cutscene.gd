extends Node2D

@export var tank_glass: Node2D
@onready var door: MultiScreenTemplate = %DoorAndPanel

func _ready():
	tank_glass.cutscene = self


func trigger_action():
	Global.level.playing_cutscene = true
	await Global.level.enter_multi_screen(door)
	for to in tank_glass.triggerable_objects:
		to.trigger_action()
	await get_tree().create_timer(3.0).timeout
	Global.level.playing_cutscene = false
	Global.blob.reset_screen()
