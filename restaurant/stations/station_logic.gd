extends Node
class_name StationLogic

signal prompts_changed(prompt)

var STATES
var curr_state 

func init_station():
	update_state(STATES.idle)

func exit() -> void:
	update_state(STATES.idle)

func highlight_prompts(input : String) -> bool:
	if !curr_state.prompts:
		return false

	var input_is_highlighted = false 

	for prompt in curr_state.prompts[0]:
		if prompt.begins_with(input):
			input_is_highlighted = true
			break

	return input_is_highlighted

func match_prompts(input: String) -> bool:
	return input in curr_state.prompts[0]

func process_prompt(prompt : String) -> bool:
	return true

func update_state(new_state : Dictionary) -> void:
	curr_state = new_state.duplicate(true)
	prompts_changed.emit(curr_state.prompts)

func _consume_state(next_state: Dictionary) -> bool:
	curr_state.prompts.pop_front()

	var transitioned = curr_state.prompts.is_empty()
	var updated_state = next_state if transitioned else curr_state

	update_state(updated_state)
	return transitioned
