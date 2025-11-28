extends Node

func _ready():
	$LevelEnd/CollisionShape2D.set_deferred("disabled", false)
