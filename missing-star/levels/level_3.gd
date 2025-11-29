extends Node

var end_screen = preload("res://ui/EndScreen.tscn").instantiate()

func _ready():
	await get_tree().process_frame

	Globals.game.snowman.sprite.animation = self.name

func _on_game_end_body_entered(_body: Node2D) -> void:
	Globals.game.set_physics_process(false)
	
	Transition.fade_in()
	await Transition.animplayer.animation_finished
	
	Globals.game.add_child(end_screen)

	Transition.hide()
	
	
