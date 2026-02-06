class_name Battery
extends RigidBody2D

@onready var wire: Line2D = %Wire
@onready var wire_origin: Marker2D = %WireOrigin
@export var blast_shield: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	wire.points = PackedVector2Array([to_local(wire_origin.global_position), to_local(global_position)])

func battery_wet():
	blast_shield.trigger_action()
