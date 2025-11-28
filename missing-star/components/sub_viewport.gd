extends SubViewport

@onready var player = $"../../../Player"
@onready var playercamera = $"../../../Player/Camera"
@export var bullshit: Node

func _ready() -> void:
	world_2d = get_tree().get_root().world_2d
	

func _physics_process(_delta: float) -> void:
	$Camera2D.position = playercamera.position
