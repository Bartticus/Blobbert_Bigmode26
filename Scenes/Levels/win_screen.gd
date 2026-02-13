extends Control
@onready var sfx : AudioStreamPlayer = $uisfx
@onready var sfx_hover : AudioStreamPlayer = $uiHoversfx
@onready var label_keys: Label = $LabelKeys
@onready var label_time: Label = $LabelTime
@onready var leaderboard_name: LineEdit = $LeaderboardName
@onready var leader_board_scene : PackedScene = preload("uid://cppg62i68ikb7")


func _ready() -> void:
	Global.time_score = floori((Time.get_ticks_msec() - Global.start_time) / 1000.0)
	
	label_keys.text = "Keys Pressed: %s" % Global.key_count
	label_time.text = "Total Time: %s" % Global.time_score + "s"

func _on_play_pressed() -> void:
	sfx.play()
	get_tree().change_scene_to_file("uid://t6j5hlf6y1hi")

func _on_credits_pressed() -> void:
	sfx.play()
	$Credits.show()

func _on_return_pressed() -> void:
	sfx.play()
	$Credits.hide()

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


func _on_post_button_pressed() -> void:
	if leaderboard_name.text == '':
		leaderboard_name.placeholder_text = 'Must Enter Name'
		return
	Global.user_name = leaderboard_name.text.replace(' ', '')
	Global.posting_score = true
	get_tree().change_scene_to_packed(leader_board_scene)
