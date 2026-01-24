# dialogue with portraits, speaker names, and optional choices
extends WindowContent
class_name DialogueContent

@onready var portrait: TextureRect = %Portrait
@onready var speaker_label: Label = %SpeakerLabel
@onready var speaker_container : HBoxContainer = $SpeakerArea/HBoxContainer
@onready var text_label: RichTextLabel = %TextLabel
@onready var choices_container: VBoxContainer = %ChoicesContainer
@onready var continue_button: Button = %ContinueButton

var dialogue_data: DialogueData
var current_line_index := 0

func setup(data: Resource) -> void:
	$".".custom_minimum_size = Vector2(400, 300)
	speaker_label.custom_minimum_size = Vector2(100, custom_minimum_size.y)
	speaker_container.custom_minimum_size = $".".custom_minimum_size
	dialogue_data = data as DialogueData
	_display_line(0)
	continue_button.pressed.connect(_on_continue)

func _display_line(index: int) -> void:
	if index >= dialogue_data.lines.size():
		#If we've shown all lines, emit completion and close
		content_completed.emit({"dialogue_id": dialogue_data.dialogue_id})
		window.close()
		return
	
	var line = dialogue_data.lines[index]
	
	if line.portrait:
		portrait.texture = line.portrait
		portrait.show()
	else:
		portrait.hide()
	
	speaker_label.text = line.speaker_name
	text_label.text = line.text
	
	# choices / continue button
	if line.choices.is_empty():
		choices_container.hide()
		continue_button.show()
	else:
		continue_button.hide()
		_build_choices(line.choices)

func _build_choices(choices: Array) -> void:
	# need to clear choices first
	for child in choices_container.get_children():
		child.queue_free()
	
	# creates choices
	for i in choices.size():
		var button = Button.new()
		button.text = choices[i]
		button.pressed.connect(_on_choice_made.bind(i))
		choices_container.add_child(button)
	
	choices_container.show()

func _on_continue() -> void:
	current_line_index += 1
	_display_line(current_line_index)

func _on_choice_made(choice_index: int) -> void:
	# emitting when choice is made
	content_completed.emit({
		"dialogue_id": dialogue_data.dialogue_id,
		"choice_index": choice_index
	})
	current_line_index += 1
	_display_line(current_line_index)
