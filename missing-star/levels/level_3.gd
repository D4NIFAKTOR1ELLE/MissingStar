extends Node

var end_screen = load("res://ui/EndScreen.tscn")

func _ready():
	await get_tree().process_frame
	
	$Game/CollisionShape2D.set_deferred("disabled", false)

func _on_game_end_body_entered(_body: Node2D) -> void:
	Globals.game.set_physics_process(false)
	
	Transition.fade_in()
	
	end_screen = end_screen.instantiate()
	
	Globals.game.add_child(end_screen)



	Transition.hide()
	
	
