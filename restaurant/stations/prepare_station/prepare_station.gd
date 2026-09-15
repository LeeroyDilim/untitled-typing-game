extends Station

var chosen_ingredient : String 

func _ready():
	STATES = {
		"idle" : {
			"state_name" : "idle",
			"prompt" : [[station_name]]
		},
		"choose_ingredient": {
			"state_name": "choose_ingredient",
			"prompt": [["pickle","onion","tomato","lettuce"]]
		},
		"chop": {
			"state_name": "chop",
			"prompt": [["chop"],["chop"],["chop"]]
		}
	}

	super._ready()

func handle_prompt(prompt : String) -> bool:
	if !super.handle_prompt(prompt):
		return false

	match curr_state.state_name:
		"idle":
			update_state(STATES.choose_ingredient)
		"choose_ingredient":
			chosen_ingredient = prompt
			update_state(STATES.chop)
		"chop":
			_consume_prompt(STATES.choose_ingredient)

	return true
