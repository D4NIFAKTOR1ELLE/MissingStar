extends Node

var snowman = preload("res://components/Snowman.tscn")
var star = preload("res://components/Star.tscn")

var level1 = preload("res://levels/Level1.tscn")
var level2 = preload("res://levels/Level2.tscn")
var level3 = preload("res://levels/Level3.tscn")

var current_level

func _ready() -> void:
	pass

func start_game():
	snowman = snowman.instantiate()
	star = star.instantiate()

func launch_level(level: Node):
	match level.name:
		"Level1":
			level1 = level1.instantiate()
			current_level = level1
		"Level2":
			level2 = level2.instantiate()
			current_level = level2
		"Level3":
			level3 = level3.instantiate()
			current_level = level3

	snowman.reparent(level)
		
	snowman.set_camera_limits()

func finish():
	pass

func set_camera_limits(map: Control):
	if map == null:
		return
	
	var map_limits = map.get_rect()
	
	snowman.camera.set_limit(SIDE_LEFT, map_limits.position.x)
	snowman.camera.set_limit(SIDE_RIGHT, map_limits.end.x)
	snowman.camera.set_limit(SIDE_TOP, map_limits.position.y)
	snowman.camera.set_limit(SIDE_BOTTOM, map_limits.end.y)
