extends Node2D

@export var tank_glass: Node2D
@onready var tank: MultiScreenTemplate = %Tank
@onready var door: MultiScreenTemplate = %DoorAndPanel
@onready var escape_marker_top: Marker2D = %EscapeMarkerTop
@onready var escape_marker_bottom: Marker2D = %EscapeMarkerBottom
@onready var fish_delete: Area2D = %FishDelete

func _ready():
	tank_glass.cutscene = self


func trigger_action():
	get_node("%FishNavRegion").switch_to_large_nav()
	Global.level.playing_cutscene = true
	for fish in get_tree().get_nodes_in_group('Fish'):
		fish.escape_marker_top = escape_marker_top
		fish.escape_marker_bottom = escape_marker_bottom
		fish.status = Fish.Status.ESCAPE
	var tween_0 = Global.level.tween_camera('position', door.screens[0].global_position - Vector2(250, 0), 1.0, Tween.TRANS_SINE)
	await tween_0.finished
	Global.sound_manager.play_required_sound('glass_break')
	for to in tank_glass.triggerable_objects:
		await get_tree().create_timer(0.02).timeout
		to.trigger_action()
	await get_tree().create_timer(3.0).timeout
	Global.level.playing_cutscene = false
	Global.blob.reset_screen()


func _on_fish_delete_body_entered(body: Node2D) -> void:
	if body.name == 'FishCharacterBody' || body.name == 'FishBody':
		body.get_parent().queue_free()
