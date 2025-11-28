extends Node

var snowman = preload("res://components/Snowman.tscn")
var star = preload("res://components/Star.tscn")

var level1 = preload("res://levels/Level1.tscn")
var level2 = preload("res://levels/Level2.tscn")
var level3 = preload("res://levels/Level3.tscn")

var current_level

func start_game():
	snowman = snowman.instantiate()
	star = star.instantiate()

	snowman.initialise()

	launch_level(level1)

func launch_level(level: PackedScene):
	current_level = level.instantiate()

	current_level.add_child(snowman)
	current_level.add_child(star)
	
	$StartScreen.hide()
	
	snowman.set_camera_limits(current_level.get_node("BG"))

func finish():
	pass
