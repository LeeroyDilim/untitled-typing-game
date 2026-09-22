extends StationLogic

var station_name: String = "register"

func init_station() -> void:
	STATES = {
		"idle" : {
			"state_name" : "idle",
			"prompts" : [[station_name]]
		},
		"take_order": {
			"state_name": "take_order",
			"prompts": [["take order"]]
		}
	}

	super.init_station()

func process_prompt(prompt : String) -> bool:
	match curr_state.state_name:
		"idle":
			update_state(STATES.take_order)
		"take_order":
			update_state(STATES.take_order)

	return true
