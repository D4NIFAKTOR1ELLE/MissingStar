extends CharacterBody2D

@export var viewport_path: NodePath
@onready var tilemap: TileMapLayer = get_node("../TileMapLayer")
@onready var viewport: SubViewport = get_node("../SubViewport")
@onready var sound = $AudioStreamPlayer

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
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		can_doublejump = true
		velocity.y = JUMP_VELOCITY
		sound.play()
	elif Input.is_action_just_pressed("ui_accept") and !is_on_floor() and can_doublejump:
		can_doublejump = false  
		velocity.y = JUMP_VELOCITY
		sound.play()
		
	if Input.is_action_just_pressed("right_click"):
		save_to()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func jump():
	pass

func die():
	set_physics_process(false)
