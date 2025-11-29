extends Area2D

@export var next_level: PackedScene

func _on_body_entered(_body: Node2D) -> void:
	Globals.game.end_level(next_level)

	self.queue_free()
