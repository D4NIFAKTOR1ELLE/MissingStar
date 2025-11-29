extends CanvasLayer

var completion_time
var ornaments_collected

func _ready() -> void:
	set_process_input(false)
	
	for element in $GridContainer:
		element.hide()

	$GridContainer/CompletionTime.text = _format_seconds(completion_time)
	$GridContainer/SecretsCollected.text = "%d / 3" % ornaments_collected

func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func reveal():
	for element in $GridContainer:
		element.show()
		
	await get_tree().create_timer(1).timeout

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("controls"):
		await next()

func next():
	set_process_input(false)
