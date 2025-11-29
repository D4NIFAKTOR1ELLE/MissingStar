extends Node

var snowman = preload("res://components/Snowman.tscn")
var star = preload("res://components/Star.tscn")

var level1 = preload("res://levels/Level1.tscn")
var level2 = preload("res://levels/Level2.tscn")
var level3 = preload("res://levels/Level3.tscn")

var current_level
var time_elapsed := 0.0

@onready var start_screen = $StartScreen

func _ready():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	time_elapsed += delta

func start_game():
	set_physics_process(true)
	
	Globals.game = self
	snowman = snowman.instantiate()
	star = star.instantiate()

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	snowman.initialise()

	launch_level(level1)

func launch_level(level: PackedScene):
	if is_instance_valid(current_level):
		current_level.queue_free()
	
	current_level = level.instantiate()
	add_child(current_level)
	
	current_level.add_child(snowman)
	current_level.add_child(star)
	
	spawn()
	
	star.initialise()
	
	snowman.set_camera_limits(current_level.get_node("Independent/BG"))

func end_level(next_level: PackedScene):
	Transition.fade_in()
	await Transition.animplayer.animation_finished
	
	current_level.remove_child(snowman)
	current_level.remove_child(star)

	await launch_level(next_level)
	
	Transition.fade_out()

func respawn():
	spawn()

func spawn():
	var spawn_point = current_level.get_node("Spawn")
	
	snowman.global_position = spawn_point.get_global_transform().origin

func finish():
	pass
