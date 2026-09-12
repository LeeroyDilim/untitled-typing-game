extends Node

var curr_input : String = ""
signal input_received(input: String, character_removed: bool)

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.is_pressed():
		return

	var event_key = event as InputEventKey
	var character_removed = false

	if event_key.keycode == KEY_BACKSPACE:
		character_removed = true
		if event.is_command_or_control_pressed():
			clear_input()
		elif not curr_input.is_empty():
			curr_input = curr_input.left(-1)
	elif event_key.unicode != 0: 
		curr_input += String.chr(event.unicode)

	curr_input = curr_input.strip_edges(true,false).to_lower() #remove leading whitespace and convert to lower case
	input_received.emit(curr_input, character_removed)

func clear_input():
	curr_input = "" 
