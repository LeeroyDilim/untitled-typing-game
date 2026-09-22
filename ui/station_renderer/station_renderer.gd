extends Control
class_name StationRenderer

@onready var prompt_container = $PanelContainer/PromptContainer
var prompt_panel_style = preload("res://ui/station_renderer/assets/station_renderer_prompt_panel_style.tres")
var inactive_prompt_panel_style = preload("res://ui/station_renderer/assets/station_renderer_inactive_prompt_panel_style.tres")
var prompt_font = preload("res://ui/assets/fonts/ticketing.regular.ttf")

#var particle_label = preload("res://ui/station_renderer/particle_label/particle_label.tscn")
#var increment_particle_flip_direction : bool = true

var base_position: Vector2
var MIN_PROMPTS_TO_RENDER = 3

func _ready():
	base_position = position

func shake() -> void:
	var tween = create_tween()
	var shake_intensity = 4.0
	var shake_duration = 0.025

	tween.tween_property(self, "position:x", base_position.x + shake_intensity, shake_duration)
	tween.tween_property(self, "position:x", base_position.x - shake_intensity, shake_duration)
	tween.tween_property(self, "position:x", base_position.x + (shake_intensity / 2), shake_duration)
	tween.tween_property(self, "position:x", base_position.x, shake_duration)

func render_highlight(input : String) -> void:
	if prompt_container.get_child_count() == 0:
		return

	var row = prompt_container.get_child(prompt_container.get_child_count() - 1)

	for panel in row.get_children():
		var center = panel.get_child(0)
		var label = center.get_child(0)
		var prompt = label.get_parsed_text()

		var match_len = _get_prefix_match_length(prompt, input)
		var highlighted_substring = prompt.substr(0, match_len)
		var unhighlighted_substring = prompt.substr(match_len)

		label.clear()
		label.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)

		if highlighted_substring.length() > 0:
			label.push_color(Color.GREEN)
			label.append_text(highlighted_substring)
			label.pop()
		label.push_color(Color.WHITE)
		label.append_text(unhighlighted_substring)
		label.pop()
		
		label.pop()

func render_prompts(prompts : Variant) -> void:
	#clear current prompt
	for child in prompt_container.get_children():
		child.queue_free()

	if !prompts:
		prompts = [[""]]
	
	var min_rows = MIN_PROMPTS_TO_RENDER 
	var rows_to_render = min(prompts.size(), min_rows)
	for prompt_index in range(rows_to_render):
		# format is [["prompt"]], where the outer array represents vertical stacking (sequential prompts),
		# and the inner array represents horizontal stacking (prompt with options)
		var row_of_prompts = prompts[prompt_index]
		var row_container = HBoxContainer.new()
		row_container.alignment = BoxContainer.ALIGNMENT_CENTER
		# display prompts bottom to top
		prompt_container.add_child(row_container)
		prompt_container.move_child(row_container,0)
		
		for prompt in row_of_prompts:
			var panel = PanelContainer.new()
			var center = CenterContainer.new()
			var label = RichTextLabel.new()
			
			#label styling
			label.bbcode_enabled = true
			label.scroll_active = false
			label.autowrap_mode = TextServer.AUTOWRAP_OFF
			label.custom_minimum_size = Vector2(90, 21)
			label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
			label.add_theme_constant_override("shadow_offset_x", 1)
			label.add_theme_constant_override("shadow_offset_y", 1)
			label.add_theme_constant_override("shadow_outline_size", 1)
			label.add_theme_font_override("normal_font", prompt_font)
			label.add_theme_font_size_override("normal_font_size", 18)
			label.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
			
			label.append_text("[center]" + prompt + "[/center]")
			
			# center label to container
			center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			center.size_flags_vertical = Control.SIZE_EXPAND_FILL
			
			if prompt_index == 0:
				panel.add_theme_stylebox_override("panel", prompt_panel_style)
				label.add_theme_color_override("default_color", Color.WHITE)
			else:
				panel.add_theme_stylebox_override("panel", inactive_prompt_panel_style)
				label.add_theme_color_override("default_color", Color.DARK_GRAY)
				
			center.add_child(label)
			panel.add_child(center)
			row_container.add_child(panel)

#func trigger_no_ingredient_particle() -> void:
	#_trigger_particle("prep required!", Vector2(-37, 0), ParticleLabel.FLOAT_DIRECTIONS.CENTER)
#
#func trigger_perfect_particle() -> void:
	#_trigger_particle("perfect!", Vector2(-8, 0), ParticleLabel.FLOAT_DIRECTIONS.CENTER)
#
#func trigger_inventory_full() -> void:
	#_trigger_particle("inventory full...", Vector2(-8, 0), ParticleLabel.FLOAT_DIRECTIONS.CENTER)
#
#func trigger_increment_particle(increment : int) -> void:
	#if increment_particle_flip_direction:
		#_trigger_particle("+" + str(increment), Vector2(-35,10), ParticleLabel.FLOAT_DIRECTIONS.LEFT)
	#else:
		#_trigger_particle("+" + str(increment), Vector2(23,10), ParticleLabel.FLOAT_DIRECTIONS.RIGHT)
	#increment_particle_flip_direction = !increment_particle_flip_direction
#
#func _trigger_particle(particle : String, placement : Vector2, floatDirection : int) -> void:
	#var newParticleLabel = particle_label.instantiate() as ParticleLabel
	#newParticleLabel.text = str(particle)
	#newParticleLabel.floatDirection = floatDirection
	#newParticleLabel.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
	#newParticleLabel.add_theme_constant_override("shadow_offset_x", 1)
	#newParticleLabel.add_theme_constant_override("shadow_offset_y", 1)
	#newParticleLabel.add_theme_constant_override("shadow_outline_size", 1)
	#newParticleLabel.add_theme_font_override("font", prompt_font)
	#newParticleLabel.global_position = global_position + placement
	#
	#get_tree().current_scene.call_deferred("add_child", newParticleLabel)

func _get_prefix_match_length(prompt : String, input : String) -> int:
	var max_len = min(input.length(), prompt.length())

	for i in range(max_len):
		if input[i] != prompt[i]:
			return 0 

	return max_len
