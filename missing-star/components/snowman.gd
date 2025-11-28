extends CharacterBody2D

@export var viewport_path: NodePath

var viewport
var sound
var camera

const SPEED = 420.0
const JUMP_VELOCITY = -420.0

var can_doublejump = true
var star_ref

func initialise():
	viewport = $SubViewport
	sound = $AudioStreamPlayer
	camera = $Camera2D

func save_to():
	viewport.world_2d = get_tree().root.get_world_2d()
	viewport.size = Vector2i((get_node("../ColorRect").size.x), get_node("../ColorRect").size.y)
	await RenderingServer.frame_post_draw
	var vt = viewport.get_texture()
	var img = vt.get_image()
	return img.save_png("user://Screenshot.png")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		can_doublejump = true
		jump()
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and can_doublejump:
		can_doublejump = false  
		jump()
		
	if Input.is_action_just_pressed("right_click"):
		save_to()

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		await fly()

func jump():
	velocity.y = JUMP_VELOCITY
	sound.play()

func fly():
	var star_position = star_ref.global_position

	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", star_position, 0.3)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await die()

func die():
	set_physics_process(false)
	
func set_camera_limits(map: Control):
	if map == null:
		return
	
	var map_limits = map.get_rect()
	
	camera.set_limit(SIDE_LEFT, map_limits.position.x)
	camera.set_limit(SIDE_RIGHT, map_limits.end.x)
	camera.set_limit(SIDE_TOP, map_limits.position.y)
	camera.set_limit(SIDE_BOTTOM, map_limits.end.y)
