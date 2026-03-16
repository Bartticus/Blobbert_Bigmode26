extends Control
@onready var sfx : AudioStreamPlayer = $uisfx
@onready var sfx_hover : AudioStreamPlayer = $uiHoversfx

func _on_play_pressed() -> void:
	sfx.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("uid://dwl5520f383c8")

func _on_credits_pressed() -> void:
	sfx.play()
	$Credits.show()
	$Cutscene.hide()

func _on_return_pressed() -> void:
	sfx.play()
	$Credits.hide()
	$Cutscene.show()

func _on_quit_pressed() -> void:
	sfx.play()
	if OS.get_name() == "Web":
		$PanelContainer/VBoxContainer/Quit.text = """This is a browser
		game lol"""
	else:
		get_tree().quit()

func _on_button_mouse_entered() -> void:
	sfx_hover.play()

func _on_leaderboard_pressed() -> void:
	sfx.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("uid://cppg62i68ikb7")
