extends CanvasLayer

@onready var sfx : AudioStreamPlayer = $uisfx
@onready var sfx_hover : AudioStreamPlayer = $uiHoversfx
@onready var resume_button: Button = $ResumeButton
@onready var restart_button: Button = $RestartButton
@onready var sliders: Control = $VolumeSliders

func _ready() -> void:
	get_tree().paused = false

func _on_button_mouse_entered() -> void:
	sfx_hover.play()

func _on_restart_button_pressed() -> void:
	sfx.play()
	get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		show_hide_pause_menu()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	resume_button.hide()
	restart_button.hide()
	sliders.hide()

func _on_stuck_button_pressed() -> void:
	show_hide_pause_menu()

func show_hide_pause_menu() -> void:
	if resume_button.visible:
		get_tree().paused = false
		resume_button.hide()
		restart_button.hide()
		sliders.hide()
	else:
		get_tree().paused = true
		resume_button.show()
		restart_button.show()
		sliders.show()
