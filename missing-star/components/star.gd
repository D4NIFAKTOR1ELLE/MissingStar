extends Sprite2D

var jump_range: int = 400

func _ready() -> void:
	set_physics_process(false)

func initialise():
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	global_position = get_viewport().get_camera_2d().get_global_mouse_position()
