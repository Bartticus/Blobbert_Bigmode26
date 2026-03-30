extends NavigationRegion2D

@onready var large_nav_region = preload('uid://dbk30s72yyw0r')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_nav_timeout() -> void:
	for fish in get_children():
		if fish is Fish:
			fish.navigation_region = self
			fish.status = Fish.Status.NAVIGATING

func switch_to_large_nav():
	navigation_polygon = large_nav_region
	bake_navigation_polygon()