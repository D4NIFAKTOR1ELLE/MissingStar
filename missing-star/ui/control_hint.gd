extends CanvasLayer

func _ready():
	hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("control_hint"):
		if visible:
			show()
		else:
			hide()
