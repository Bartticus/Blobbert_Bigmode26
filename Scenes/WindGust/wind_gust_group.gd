extends Node2D

@export var time_offset: float = 0.5
@export var auto_start: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if auto_start:
		start_wave()

func start_wave() -> void:
	var children = get_children()
	var fake_i = 0
	for i in get_children().size():
		children[i].repeat_timer.stop()
		fake_i += 1
		if !children[i].active:
			fake_i -= 1
			continue
		children[i].time_offset = time_offset * fake_i
		children[i].offset_timer.start((time_offset * fake_i) + 0.01)



func trigger_action():
	start_wave()
