extends CanvasLayer

var next_lv

func _ready():
	set_process_input(false)
	$BG.hide()
	$BG/UpperTitle.hide()
	$BG/LowerTitle.hide()
	
	print(Globals.game.current_level.name)
	if Globals.game.current_level.name == "Level2":
		$BG/UpperTitle.text = "YOU GOT A LITTLE [color=yellow]BOWTIE[/color]!"
		$BG/LowerTitle.text = "[right]LOOKIN' EVEN NICER PAL[font_size=30]\nPress [color=yellow][C][/color] to continue [/font_size][/right]"
	
func reveal():
	Transition.fade_in()
	
	await get_tree().create_timer(2).timeout
	$BG.show()
	
	Transition.hide()
	
	$BG/UpperTitle.show()

	await get_tree().create_timer(2).timeout

	$BG/LowerTitle.show()

	set_process_input(true)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("controls"):
		next(next_lv)
		
func next(next_level: PackedScene):	
	Transition.show()

	Globals.game.end_level(next_level)
	
	self.queue_free()
