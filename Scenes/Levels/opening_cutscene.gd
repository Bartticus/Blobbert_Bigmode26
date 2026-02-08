extends LevelScript

@onready var bg_sprite = %BGSprite
@onready var bg_sprite_2 = %BGSprite2
@onready var comb = %Comb
@onready var comb_move = %CombMove
@onready var splat = %Splatter
@onready var vent = %VentZoom
@onready var blob_zoom = %BlobZoom
@onready var dead_blob = %DeadBlob
@onready var screen_blob = %ScreenBlob3
@onready var loading_zone = %LoadingZone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_cutscene()

func play_cutscene():

	print('ok')
	await get_tree().create_timer(2.0).timeout
	Global.level.camera.global_position = bg_sprite_2.global_position
	await get_tree().create_timer(1.0).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(comb, 'global_position', comb_move.global_position, 1.0)
	await tween.finished
	Global.level.camera.global_position = bg_sprite.global_position
	splat.visible = true
	var tween2 = get_tree().create_tween()
	tween2.tween_property(splat, 'global_position', vent.global_position, 1.0)
	await tween2.finished
	var tween3 = get_tree().create_tween()
	tween3.tween_property(splat, 'global_position', blob_zoom.global_position, 1.0)
	await tween3.finished
	splat.visible = false
	dead_blob.visible = false
	screen_blob.visible = true
	await get_tree().create_timer(2.0).timeout
	loading_zone.load_next()
