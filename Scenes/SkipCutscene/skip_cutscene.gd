extends Control

@onready var skip_button: Button = %SkipButton
@onready var hold_timer: Timer = %HoldTimer

@export var cutscene: Node2D

func _ready():
	print('hide')
	hide()
	process_mode = PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	global_position = Global.keeb.global_position
	print(global_position)
	scale = Global.keeb.global_position

func start_cutscene():
	skip_button.call_deferred("grab_focus")
	process_mode = PROCESS_MODE_INHERIT
	print('show')
	show()

func _on_skip_button_button_down() -> void:
	print('down')
	hold_timer.start()

func _on_skip_button_button_up() -> void:
	print("up")
	hold_timer.stop()

func _on_hold_timer_timeout() -> void:
	if cutscene:
		cutscene.skip_cutscene()
	hide()
	skip_button.queue_free()
