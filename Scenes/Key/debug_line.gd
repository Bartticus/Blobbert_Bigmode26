extends Line2D


func draw_line_to_bone(bone) -> void:
	points = [
		position,
		to_local(bone.global_position)
	]
