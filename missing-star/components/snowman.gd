extends CharacterBody2D

@export var viewport_path: NodePath
@onready var viewport: SubViewport = $SubViewport
@onready var sound = $AudioStreamPlayer
@onready var camera = $Camera2D

const SPEED = 420.0
const JUMP_VELOCITY = -420.0

var can_doublejump = true

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

func jump():
	velocity.y = JUMP_VELOCITY
	sound.play()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await die()

func die():
	set_physics_process(false)
