extends Area2D

@export var grate: Node2D


func _on_body_entered(body: Node2D) -> void:
	if body is Bone:
		if grate:
			grate.activated = true

