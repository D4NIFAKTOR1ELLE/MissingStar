extends CharacterBody2D

@export var viewport_path: NodePath

@onready var viewport = $SubViewport
@onready var sound = $AudioStreamPlayer
@onready var camera = $Camera2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation = $AnimationPlayer

const SPEED = 400.0
const JUMP_VELOCITY = -350.0
const MAX_DASH_SPEED := 500.0

var jump_range: int = 300
var can_fly := true
var is_dashing: bool = false
var dash_velocity: Vector2
var jumps_left: int = 1
const MAX_JUMPS = 1

var dash_remaining_distance: float

func initialise():
	pass

func save_to():
	viewport.world_2d = get_tree().root.get_world_2d()
	viewport.size = Vector2i(
		(Globals.game.current_level.get_node("Independent/BG").size.x),
		Globals.game.current_level.get_node("Independent/BG").size.y)
	await RenderingServer.frame_post_draw
	var vt = viewport.get_texture()
	var img = vt.get_image()
	print("Image saved!")
	return img.save_png("user://Screenshot.png")

func _physics_process(delta: float) -> void:
	if is_on_floor():
		animation.play("idle")
		set_process_input(true)
		can_fly = true
		jumps_left = MAX_JUMPS

	if is_dashing:
		dash_movement(delta)
	else:
		normal_movement(delta)

	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

	move_and_slide()

func dash_movement(delta: float):
	var movement = dash_velocity * delta

	dash_remaining_distance -= movement.length()

	if dash_remaining_distance <= 0.0:
		animation.play("dash_exit")
		await animation.animation_finished
		set_process_input(true)
		is_dashing = false
		velocity = Vector2.ZERO

	velocity = dash_velocity

func normal_movement(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("left_click") and !is_dashing:
		await fly()
	if Input.is_action_just_pressed("right_click"):
		save_to()
	if Input.is_action_pressed("jump") and jumps_left > 0 and !is_dashing:
		jump()
		jumps_left -= 1

func jump():
	animation.play("rise")
	velocity.y = JUMP_VELOCITY
	await animation.animation_finished
	sound.play()
	animation.play("fall")

func start_recovery():
	animation.play("recovery")

func fly():
	if not can_fly:
		return

	animation.play("dash_init")
	await animation.animation_finished

	set_process_input(false)

	var to_star = (Globals.game.star.global_position - global_position)
	var distance_to_star = to_star.length()
	var direction = to_star.normalized()

	dash_remaining_distance = min(distance_to_star, jump_range)

	dash_velocity = direction * MAX_DASH_SPEED

	is_dashing = true
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
