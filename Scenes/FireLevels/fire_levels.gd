extends Node2D

@onready var first_level: Area2D = %FirstLevel
@onready var second_level: Area2D = %SecondLevel
@onready var third_level: Area2D = %ThirdLevel

var level_names = ['FirstLevel', 'SecondLevel', 'ThirdLevel']


func on_level_area_entered(area: Area2D, level_name) -> void:
	if area.name == 'FireLevelArea':
		area.get_parent().add_to_group(level_name)
	if area.name == 'OilDetector':
		activate_fire_in_area(level_name)
		var other_two_levels = level_names.filter(func (l): return l != level_name)
		for level in other_two_levels:
			deactivate_fire_in_area(level)

func _on_first_level_area_entered(area: Area2D) -> void:
	on_level_area_entered(area, 'FirstLevel')

func _on_second_level_area_entered(area: Area2D) -> void:
	on_level_area_entered(area, 'SecondLevel')

func _on_third_level_area_entered(area: Area2D) -> void:
	on_level_area_entered(area, 'ThirdLevel')



func on_level_area_exited(area: Area2D, level_name) -> void:
	if area.name == 'FireLevelArea':
		area.get_parent().remove_from_group(level_name)

func _on_first_level_area_exited(area: Area2D) -> void:
	on_level_area_exited(area, 'FirstLevel')

func _on_second_level_area_exited(area: Area2D) -> void:
	on_level_area_exited(area, 'SecondLevel')

func _on_third_level_area_exited(area: Area2D) -> void:
	on_level_area_exited(area, 'ThirdLevel')


func deactivate_fire_in_area(level_name):
	for fire in get_tree().get_nodes_in_group(level_name):
		fire.deactivate()

func activate_fire_in_area(level_name):
	for fire in get_tree().get_nodes_in_group(level_name):
		if fire.enable_on_floor_enter:
			fire.activate()