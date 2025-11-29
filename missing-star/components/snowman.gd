extends CharacterBody2D

@export var viewport_path: NodePath

@onready var viewport = $SubViewport
@onready var sound= $AudioStreamPlayer
@onready var camera = $Camera2D
@onready var sprite = $Sprite

const SPEED = 400.0
const JUMP_VELOCITY = -350.0
var fly_duration: float = 0.3
var jump_range: int = 400

var can_fly := true
var is_dashing: bool = false
var dash_timer := 0.2
var dash_velocity: Vector2
var jumps_left: int = 1
const MAX_JUMPS = 1

func initialise():
	pass

func save_to():
	viewport.world_2d = get_tree().root.get_world_2d()
	viewport.size = Vector2i((get_node("../ColorRect").size.x), get_node("../ColorRect").size.y)
	await RenderingServer.frame_post_draw
	var vt = viewport.get_texture()
	var img = vt.get_image()
	return img.save_png("user://Screenshot.png")

func _physics_process(delta: float) -> void:
	if is_on_floor():
		can_fly = true
		jumps_left = MAX_JUMPS
	
	if not is_dashing and not is_on_floor():
		velocity += get_gravity() * delta

	if not is_dashing:
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_dashing:
		dash_timer -= delta
		velocity = dash_velocity
		if dash_timer <= 0.0:
			is_dashing = false

	sprite.flip_h = velocity.x < 0

	move_and_slide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		fly()
	if Input.is_action_just_pressed("right_click"):
		save_to()
	if Input.is_action_pressed("jump") and jumps_left > 0:
		jump()
		jumps_left -= 1

func jump():
	velocity.y = JUMP_VELOCITY
	sound.play()

func fly():
	if not can_fly:
		return

	var star_position = Globals.game.star.global_position
	var direction: Vector2 = (star_position - global_position).normalized()

	var dash_speed = jump_range / fly_duration

	dash_velocity = direction * dash_speed

	is_dashing = true
	dash_timer = fly_duration

	can_fly = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await die()

func die():
	stop(false)

	Transition.fade_in()
	await Transition.animplayer.animation_finished

	await Globals.game.respawn()
	await stop(true)
	
	Transition.fade_out()
	
func stop(enable: bool = false):
	set_physics_process(enable)
	set_process_input(enable)

func set_camera_limits(map: Control):
	if map == null:
		return
	
	var map_limits = map.get_rect()
	
	camera.set_limit(SIDE_LEFT, map_limits.position.x)
	camera.set_limit(SIDE_RIGHT, map_limits.end.x)
	camera.set_limit(SIDE_TOP, map_limits.position.y)
	camera.set_limit(SIDE_BOTTOM, map_limits.end.y)
