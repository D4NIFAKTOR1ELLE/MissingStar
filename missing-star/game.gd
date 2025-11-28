extends Node

var snowman = preload("res://components/Snowman.tscn")
var star = preload("res://components/Star.tscn")

var level1 = preload("res://levels/Level1.tscn")
var level2 = preload("res://levels/Level2.tscn")
var level3 = preload("res://levels/Level3.tscn")

var current_level

@onready var start_screen = $StartScreen

func start_game():
	snowman = snowman.instantiate()
	star = star.instantiate()

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	snowman.star_ref = star
	snowman.initialise()

	launch_level(level1)

func launch_level(level: PackedScene):
	current_level = level.instantiate()
	add_child(current_level)
	
	current_level.add_child(snowman)
	current_level.add_child(star)
	
	spawn()
	
	star.initialise()
	remove_child(start_screen)
	
	snowman.set_camera_limits(current_level.get_node("BG"))

func spawn():
	var spawn_point = current_level.get_node("Spawn")
	
	snowman.global_position = spawn_point.get_global_transform().origin

func finish():
	pass
