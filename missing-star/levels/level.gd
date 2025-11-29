extends Node

func _ready():
	$LevelEnd/CollisionShape2D.set_deferred("disabled", false)

	await get_tree().process_frame

	Globals.game.snowman.sprite.animation = self.name
