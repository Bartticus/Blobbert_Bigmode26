extends Control

@onready var scores_container := %ScoresContainer as VBoxContainer
@onready var single_score : PackedScene = preload("uid://dlvrj547ca4f6")
@onready var loading_label := %LoadingLabel as Label
@onready var high_scores_label := %HighScoresLabel as Label
@onready var switch : Button = %Switch

var current_board = 'time'
var labels_dict = {
	'time': { 'name': 'keys_pressed', 'label': 'KEYS PRESSED'},
	'keys_pressed': { 'name': 'time', 'label': 'TIME TAKEN' }
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.posting_score:
		await Talo.players.identify('user_name', Global.user_name)
		await Talo.leaderboards.add_entry('time', Global.time_score, { user_name = Global.user_name })
		await Talo.leaderboards.add_entry('keys_pressed', Global.key_count, { user_name = Global.user_name })
		Global.posting_score = false
	get_scores()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://b4o23ec1ofw0u")


func _on_timer_timeout() -> void:
	if loading_label.text.length() > 9:
		loading_label.text = 'LOADING'
	else:
		loading_label.text = loading_label.text + '.'

func get_scores():
	loading_label.visible = true
	var results = await Talo.leaderboards.get_entries(current_board)
	loading_label.visible = false
	var entries = results['entries']

	for entry in entries:
		var new_score = single_score.instantiate()
		scores_container.add_child(new_score)
		new_score.constructor({ 'rank': entry.position + 1, 'score': entry.score, 'name': entry.get_prop('user_name') })


func _on_switch_pressed() -> void:
	for score in scores_container.get_children():
		score.queue_free()
	high_scores_label.text = labels_dict[current_board].get('label')
	current_board = labels_dict[current_board].get('name')
	switch.text = labels_dict[current_board].get('label')
	get_scores()
	
