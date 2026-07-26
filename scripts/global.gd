extends Node

var player: Player

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_released() and event.keycode == KEY_ESCAPE:
			get_tree().quit()
