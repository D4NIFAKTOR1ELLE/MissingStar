extends CanvasLayer

@onready var animplayer: AnimationPlayer = $AnimationPlayer

func _ready():
	hide()
	animplayer.speed_scale = 1.8

func fade_in():
	show()
	animplayer.play("fade_in")
	
func fade_out():
	animplayer.play("fade_out")
