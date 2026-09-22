extends Player
class_name TestPlayer

@export var navigation_timer: Timer
var current_station: Station
var current_input: String

func navigateToStation(station: Station, input: String) -> void:
	current_station = station
	current_input = input
	navigation_timer.start(2.5)

func onStationArrival() -> void:
	current_station.process_prompt(current_input)
