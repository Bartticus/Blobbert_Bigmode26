extends Node2D

@export var battery: Battery
@export var triggerable_objects: Array[Node2D]
@export var fish: Array[Fish]
@export var skipping_cutscene: bool = false

@onready var tank: MultiScreenTemplate = %Tank
@onready var skip_cutscene_ui = %SkipCutscene

func _ready():
	battery.cutscene = self


func trigger_action():
	skip_cutscene_ui.start_cutscene()
	Global.level.playing_cutscene = true
	if !skipping_cutscene:
		await Global.level.enter_multi_screen(tank)
		var tween_0 = Global.level.tween_camera('position', tank.screens[2].global_position, 1.5, Tween.TRANS_SINE)
		await tween_0.finished
	await get_tree().create_timer(0.5).timeout
	battery.trigger_action()
	await get_tree().create_timer(0.5).timeout
	for to in triggerable_objects:
		to.trigger_action()
	for f in fish:
		f.status = Fish.Status.CHARGE_GLASS
	if !skipping_cutscene:
		await get_tree().create_timer(3.0).timeout
		Global.level.playing_cutscene = false
		Global.blob.reset_screen()


func _on_area_2d_body_entered(body: Node2D) -> void:
	trigger_action()

func skip_cutscene():
	Global.level.playing_cutscene = false
	skipping_cutscene = true
	Global.blob.reset_screen()
