extends CanvasLayer

func _on_start_pressed() -> void:
	get_tree().root.get_node("Game").start_game()
	
	Transition.show()
	
	queue_free()

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
