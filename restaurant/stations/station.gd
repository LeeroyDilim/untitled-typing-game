extends Node
class_name Station

@export var station_renderer: StationRenderer
@export var station_logic: StationLogic

var station_name: String = ""

signal update_prompt_ui(prompt)
signal update_highlight_ui(input)
signal trigger_mistype_anim()

func _ready() -> void:
	station_name = station_logic.station_name

	update_prompt_ui.connect(station_renderer.render_prompts)
	update_highlight_ui.connect(station_renderer.render_highlight)
	trigger_mistype_anim.connect(station_renderer.shake)
	station_logic.prompts_changed.connect(_on_prompts_update)

	station_logic.init_station()

func exit() -> void:
	station_logic.exit()

func highlight_prompts(input : String) -> bool:
	update_highlight_ui.emit(input)
	return station_logic.highlight_prompts(input)

func match_prompts(input: String) -> bool:
	return station_logic.match_prompts(input)

func process_prompt(input : String) -> bool:
	return station_logic.process_prompt(input)
	
func handle_misinput() -> void:
	trigger_mistype_anim.emit()
	update_highlight_ui.emit("")

func _on_prompts_update(prompts: Variant) -> void:
	update_prompt_ui.emit(prompts)
	
