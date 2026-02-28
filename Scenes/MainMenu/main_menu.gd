extends Control
@onready var sfx : AudioStreamPlayer = $uisfx
@onready var sfx_hover : AudioStreamPlayer = $uiHoversfx

func _on_play_pressed() -> void:
	sfx.play()
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
	$PanelContainer/VBoxContainer/Quit.text = """This is a browser
	game lol"""

func _on_play_mouse_entered() -> void:
	sfx_hover.play()

func _on_credits_mouse_entered() -> void:
	sfx_hover.play()

func _on_quit_mouse_entered() -> void:
	sfx_hover.play()

func _on_return_mouse_entered() -> void:
	sfx_hover.play()


func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("uid://cppg62i68ikb7")
