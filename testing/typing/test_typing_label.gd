extends Label

func _on_test_typing_input_received(curr_input: String, was_backspace: bool) -> void:
	text = "Current input: [%s]\nBackspace: %s" % [curr_input, was_backspace]
