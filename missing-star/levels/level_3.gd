extends Node
																																			 
func _ready():
	await get_tree().process_frame
	
	$Game/CollisionShape2D.set_deferred("disabled", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
