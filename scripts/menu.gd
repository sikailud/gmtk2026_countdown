extends CanvasLayer

func toggle_pause() -> void:
	if get_tree().paused:
		visible = false
		get_tree().paused = false
	else:
		visible = true
		get_tree().paused = true

func _ready() -> void:
	toggle_pause()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()


func _on_button_pressed() -> void:
	toggle_pause()
