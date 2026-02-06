extends Node2D


func _on_fire_detection_area_entered(area: Area2D) -> void:
	if area.name == 'AdjacentOilChecker':
		if !area.owner.ignited:
			area.owner.ignite()
