extends Area2D

@onready var animation = $AnimationPlayer

func _ready() -> void:
	$Collision.set_deferred("disabled", false)

	await get_tree().process_frame

func _on_body_entered(_body: Node2D) -> void:
	animation.play("collected")
	await animation.animation_finished

	Globals.game.ornaments_collected += 1
	
	self.queue_free()
