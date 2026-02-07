class_name MultiScreenTemplate
extends Node2D

@export var screens: Array[Screen] = []


func _ready():
	for screen in get_children():
		if screen is Screen:
			screens.append(screen)
			screen.multi_screen = self

