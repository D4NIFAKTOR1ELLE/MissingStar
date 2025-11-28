extends Sprite2D

var jump_range: int = 400

func _ready() -> void:
	set_physics_process(false)

func initialise():
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	global_position = get_viewport().get_mouse_position()

#ALERT The parametric equation to make the player jump work
	#var target = player.get_global_mouse_position()
	#var angle = target.direction_to(player.movement.global_position).angle()
	#
	#global_position.x = player.movement.global_position.x - jump_range * cos(angle)
	#global_position.y = player.movement.global_position.y - jump_range * sin(angle)
