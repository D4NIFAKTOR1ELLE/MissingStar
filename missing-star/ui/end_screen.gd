extends CanvasLayer

var completion_time
var ornaments_collected

func _ready() -> void:
	set_process_input(false)

	$RichTextLabel.hide()
	$Quit.hide()
	for element in $GridContainer.get_children():
		element.hide()
	
	completion_time = Globals.game.time_elapsed
	ornaments_collected = Globals.game.ornaments_collected
	
	await get_tree().create_timer(2).timeout

	$RichTextLabel.show()

	$GridContainer/CompletionTime.text = _format_seconds(completion_time)
	$GridContainer/SecretsCollected.text = "%d / 3" % ornaments_collected
	
	await get_tree().create_timer(2).timeout
	
	reveal()

func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func reveal():
	for element in $GridContainer.get_children():
		element.show()
	
		await get_tree().create_timer(1).timeout
		
	await get_tree().create_timer(1).timeout
	$Quit.show()
	set_process_input(true)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("controls"):
		await next()

func next():
	get_tree().quit()
