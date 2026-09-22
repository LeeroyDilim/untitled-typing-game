extends StationLogic

var station_name: String = "prepare"
var chosen_ingredient: String 

func init_station() -> void:
	STATES = {
		"idle" : {
			"state_name" : "idle",
			"prompts" : [[station_name]]
		},
		"choose_ingredient": {
			"state_name": "choose_ingredient",
			"prompts": [["pickle","onion","tomato","lettuce"]]
		},
		"chop": {
			"state_name": "chop",
			"prompts": [["chop"],["chop"],["chop"]]
		}
	}

	super.init_station()

func process_prompt(prompt : String) -> bool:
	match curr_state.state_name:
		"idle":
			update_state(STATES.choose_ingredient)
		"choose_ingredient":
			chosen_ingredient = prompt
			update_state(STATES.chop)
		"chop":
			_consume_state(STATES.choose_ingredient)

	return true
