extends Area2D

var in_between = load("res://ui/InBetween.tscn")

@export var next_level: PackedScene

func _on_body_entered(_body: Node2D) -> void:
	$AnimationPlayer.play("pickup")
	await $AnimationPlayer.animation_finished
	
	in_between = in_between.instantiate()
	Globals.game.add_child(in_between)

	await get_tree().process_frame
	
	in_between.next_lv = next_level
	in_between.reveal()
	
	await get_tree().process_frame
	self.queue_free()
