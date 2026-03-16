extends CanvasLayer

@onready var sfx : AudioStreamPlayer = $uisfx
@onready var sfx_hover : AudioStreamPlayer = $uiHoversfx
@onready var buttons: Control = $Buttons
@onready var sliders: Control = $VolumeSliders

func _ready() -> void:
	get_tree().paused = false

func _on_button_mouse_entered() -> void:
	sfx_hover.play()

func _on_restart_button_pressed() -> void:
	sfx.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		show_hide_pause_menu()

func _on_resume_button_pressed() -> void:
	sfx.play()
	get_tree().paused = false
	buttons.hide()
	sliders.hide()

func _on_stuck_button_pressed() -> void:
	sfx.play()
	show_hide_pause_menu()

func _on_layout_button_pressed() -> void:
	sfx.play()
	Global.keeb.set_key_positions()

func show_hide_pause_menu() -> void:
	if buttons.visible:
		get_tree().paused = false
		buttons.hide()
		sliders.hide()
	else:
		get_tree().paused = true
		buttons.show()
		sliders.show()


func _on_menu_button_pressed() -> void:
	sfx.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("uid://b4o23ec1ofw0u")
