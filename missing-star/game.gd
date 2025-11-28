extends Node

var snowman = preload("res://components/Snowman.tscn")
var star = preload("res://components/Star.tscn")

var level1 = preload("res://levels/Level1.tscn")
var level2 = preload("res://levels/Level2.tscn")
var level3 = preload("res://levels/Level3.tscn")

var current_level

@onready var start_screen = $StartScreen

func start_game():
	Globals.game = self
	snowman = snowman.instantiate()
	star = star.instantiate()

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	snowman.star_ref = star
	snowman.game_ref = self
	snowman.initialise()

	launch_level(level1)

func launch_level(level: PackedScene):
	current_level = level.instantiate()
	add_child(current_level)
	
	current_level.add_child(snowman)
	current_level.add_child(star)
	
	spawn()
	
	star.initialise()

	if is_instance_valid(start_screen):
		remove_child(start_screen)
	
	snowman.set_camera_limits(current_level.get_node("BG"))

func end_level():
	Transition.fade_in()
	await Transition.animplayer.animation_finished
	
	current_level.remove_child(snowman)
	current_level.remove_child(star)
	
	current_level = level2
	await launch_level(level2)
	
	Transition.fade_out()

func respawn():
	spawn()

func spawn():
	var spawn_point = current_level.get_node("Spawn")
	
	snowman.global_position = spawn_point.get_global_transform().origin

func finish():
	pass
