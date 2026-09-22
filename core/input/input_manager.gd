extends Node
class_name InputManager

@export var player : Player

signal clear_input

var stations : Array[Station] = []
var station_names : Array[String] = [] 
var curr_station : Station = null

var typing_streak : int = 0
var highest_typing_streak : int = 0
var input_is_mistype : bool = false

func init_input_manager():
	# collect every node that belongs to the "station" group
	# note that these are all PARENT nodes, not their logic children
	for node in get_tree().get_nodes_in_group("station"):
		var station = node as Station
		if station:
			add_station(station)
	
func add_station(station: Station):
	if not stations.has(station):
		stations.append(station)
		station_names.append(station.station_name)

func remove_station(station: Station):
	if stations.has(station):
		stations.erase(station)
		station_names.erase(station.station_name)

func process_input(input: String, char_removed: bool) -> void:
	var input_is_highlighted := false 
	var prompt_match := false 
	var matching_station : Station = null
	
	for station in stations:
		input_is_highlighted = input_is_highlighted or station.highlight_prompts(input)
		if station.match_prompts(input):
			prompt_match = true
			matching_station = station 
	
	# if current player input does not match or partially match
	# with any of the active station prompts, identify it as a mistype
	if !input_is_highlighted && !char_removed && curr_station:
		_handle_mistype()

	if prompt_match:
		_handle_prompt_match(matching_station, input)

func _handle_prompt_match(matching_station: Station, input: String) -> void:
	input_is_mistype = false
	#scoringSystem.incrementScoreInstance(SCORES.PROMPT_COUNT)
	
	typing_streak += 1
	#if typing_streak > highest_typing_streak:
		#scoringSystem.incrementScoreInstance(SCORES.TYPING_STREAK)

	clear_input.emit()

	#if player chooses to navigate to different station
	if input in station_names:
		if curr_station:
			curr_station.exit()
		curr_station = matching_station
		player.navigateToStation(matching_station, input)
	else:
		matching_station.process_prompt(input)

func _handle_mistype() -> void:
	if typing_streak > highest_typing_streak:
		highest_typing_streak = typing_streak
	typing_streak = 0 
	
	#if player mistyped, only count it once
	#do not count any sequential mistypes until after player successfully submits a prompt
	if(!input_is_mistype):
		#scoringSystem.incrementScoreInstance(SCORES.MISTYPE)
		input_is_mistype = true

	curr_station.handle_misinput()
