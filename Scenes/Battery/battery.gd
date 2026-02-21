class_name Battery
extends Node2D

@onready var wire: Line2D = %Wire
@onready var wire_origin: Marker2D = %WireOrigin
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var battery_body: RigidBody2D = %BatteryBody

@export var wet: bool = false
@export var cutscene: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	wire.points = PackedVector2Array([to_local(wire_origin.global_position), to_local(battery_body.global_position)])

func trigger_action():
	if !wet:
		wet = true
		if cutscene:
			cutscene.trigger_action()
		await get_tree().create_timer(0.2).timeout
		animation_player.play("boom")
		Global.sound_manager.play_required_sound('explosion')
		wire.visible = false
		modulate = Color(0.3, 0.3, 0.3)
		await animation_player.animation_finished


