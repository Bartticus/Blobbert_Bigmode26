class_name Fish
extends Node2D

@export var target: Vector2
@export var max_speed: float = 100.0
@export var navigation_region: NavigationRegion2D
@export var waiting: bool = true
@export var bumper_velocity: Vector2 = Vector2(0,0)
@export var desired_angle: float = 0.0

@onready var nav_agent: NavigationAgent2D = %NavAgent
@onready var fish_body: RigidBody2D = %FishBody
@onready var fish_char: CharacterBody2D = %FishCharacterBody
@onready var bump_timer: Timer = %BumpTimer
@onready var fish_sprite: Sprite2D = %FishSprite

enum Status { WAITING, NAVIGATING, BUMPED }
var status: Status = Status.WAITING : set = set_status

func set_status(new_status):
	status = new_status
	match status:
		Status.WAITING:
			fish_body.process_mode = Node.PROCESS_MODE_DISABLED
			pass
		Status.NAVIGATING:
			fish_char.global_position = fish_body.global_position
			fish_char.global_rotation = fish_body.global_rotation
			fish_body.process_mode = Node.PROCESS_MODE_DISABLED
			get_nav_point()
		Status.BUMPED:
			fish_char.velocity = Vector2(0,0)
			bump_timer.start()
			fish_body.process_mode = Node.PROCESS_MODE_INHERIT
			fish_body.apply_force(bumper_velocity.direction_to(fish_body.global_position))


func _ready():
	nav_agent.max_speed = max_speed
	nav_agent.velocity_computed.connect(velocity_computed)

func get_nav_point():
	target = NavigationServer2D.region_get_random_point(navigation_region.get_rid(), 1, true)
	nav_agent.target_position = target
	global_position = fish_char.global_position
	fish_char.position = Vector2(0,0)

func _physics_process(delta):
	if (nav_agent.is_navigation_finished() && status == Status.NAVIGATING):
		get_nav_point()
	elif (status == Status.NAVIGATING):
		calculate_nav(delta)

func calculate_nav(delta):
	var nav_direction = to_local(nav_agent.get_next_path_position()).normalized()
	var new_velocity = nav_direction * max_speed
	nav_agent.velocity = new_velocity
	if new_velocity.x < 0:
		fish_sprite.flip_h = true
	else:
		fish_sprite.flip_h = false

	handle_rotations(delta)


func handle_rotations(delta):
	if fish_char.rotation != 0:
		fish_char.rotation = lerp_angle(fish_char.rotation, 0, delta * 2)
	fish_sprite.rotation = lerp_angle(fish_sprite.rotation, desired_angle, (delta * 0.7))

func velocity_computed(safe_velocity):
	if status == Status.NAVIGATING:
		fish_char.velocity = safe_velocity
		fish_char.move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Bone:
		status = Status.BUMPED
		bumper_velocity = body.linear_velocity


func _on_bump_timer_timeout() -> void:
	status = Status.NAVIGATING


func _on_wiggle_timer_timeout() -> void:
	desired_angle = randf_range(-0.4, 0.4)
