extends Label

func _on_test_typing_input_updated(input: String, char_removed: bool) -> void:
	text = "Current input: [%s]\nChar removed: %s" % [input, char_removed]
