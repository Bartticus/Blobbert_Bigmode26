extends Control
@onready var sfx : AudioStreamPlayer = $uisfx
@onready var sfx_hover : AudioStreamPlayer = $uiHoversfx
@onready var label_keys: Label = $LabelKeys
@onready var label_time: Label = $LabelTime
var total_time: int

func _ready() -> void:
	total_time = floori((Time.get_ticks_msec() - Global.start_time) / 1000.0)
	
	label_keys.text = "Keys Pressed: %s" % Global.key_count
	label_time.text = "Total Time: %s" % total_time + "s"

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
