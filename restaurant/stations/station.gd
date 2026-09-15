extends Node
class_name Station

@export var station_name : String

signal prompts_updated(prompt)
signal highlight_prompt(input)
signal prompt_mistyped()

var STATES
var curr_state 

func _ready():
	curr_state = STATES.idle

func start_station() -> void:
	prompts_updated.emit(curr_state.prompt)

func leave_station() -> void:
	update_state(STATES.idle)

func highlight_input(input : String) -> bool:
	if !curr_state.prompt:
		return false

	var input_is_highlighted = false 
	highlight_prompt.emit(input)

	for prompt in curr_state.prompt[0]:
		if prompt.begins_with(input):
			input_is_highlighted = true
			break

	return input_is_highlighted

func handle_misinput() -> void:
	prompt_mistyped.emit()
	highlight_prompt.emit("")

func handle_prompt(prompt : String) -> bool:
	if !curr_state.prompt:
		return false
	
	return prompt in curr_state.prompt[0]

func update_state(new_state : Dictionary) -> void:
	curr_state = new_state.duplicate(true)

func _consume_prompt(next_state: Dictionary) -> bool:
	curr_state.prompt.pop_front()

	var transitioned = curr_state.prompt.is_empty()
	var updated_state = next_state if transitioned else curr_state

	update_state(updated_state)
	return transitioned
