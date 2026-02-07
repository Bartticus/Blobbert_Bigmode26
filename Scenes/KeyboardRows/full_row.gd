@tool
extends Node2D


@export var snap_keys_to_position: bool = false:
	set(value):
		snap_keys_to_position = value
		if snap_keys_to_position and Engine.is_editor_hint():
			set_key_positions()

func set_key_positions():
	for key in get_children():
		key.set_key_label(str(key.name))