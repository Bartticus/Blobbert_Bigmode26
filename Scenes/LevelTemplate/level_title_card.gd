extends Control

@onready var level_name_label: Label = %LevelNameLabel
@onready var timer: Timer = %Timer

@export var level_name: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_name_label.text = level_name

func fade_in():
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	visible = true
	var tween = get_tree().create_tween()
	tween.set_ignore_time_scale()
	tween.tween_property(self, 'modulate', Color(1.0, 1.0, 1.0, 1.0), 1.0)
	return tween

func _on_timer_timeout() -> void:
	Global.level.fade_title_card()
