#  interactive tasks, typing challenges or multiple-choice questions or something elsee ?
extends WindowContent
class_name TaskContent

@onready var prompt_label: RichTextLabel = %PromptLabel
@onready var input_container: VBoxContainer = %InputContainer
@onready var feedback_label: Label = %FeedbackLabel
@onready var submit_button: Button = %SubmitButton

var task_data: TaskData
var attempts := 0
var start_time := 0.0

func setup(data: Resource) -> void:
	if data == null:
		push_error("TaskContent.setup() received invalid data")
		return
	#casting
	task_data = data as TaskData

	if task_data == null:
		push_error("TaskContent.setup() received data that is not TaskData and cannot be casted")
		return

	if prompt_label == null:
		push_error("PromptLabel is invalid")
		return

	prompt_label.add_theme_color_override("default_color", Color.WHITE)
	
	#FIXME: this was suggested by claude after several tries trying to center stuff. But doesn't look elegant ....
	prompt_label.text = "[center]" + task_data.prompt + "[/center]"

	_build_input_ui()

	if submit_button:
		submit_button.text = task_data.submit_button_text
		submit_button.pressed.connect(_on_submit)
		submit_button.add_theme_color_override("font_color", Color.WHITE)

	if feedback_label:
		feedback_label.add_theme_color_override("font_color", Color.RED)

	start_time = Time.get_ticks_msec() / 1000.0

func _build_input_ui() -> void:
	match task_data.task_type:
		TaskData.Type.TYPING:
			_create_text_input()
		TaskData.Type.MULTIPLE_CHOICE:
			_create_choice_buttons()

func _create_text_input() -> void:
	var line_edit = LineEdit.new()
	line_edit.placeholder_text = task_data.hint
	line_edit.custom_minimum_size = Vector2(300, 40)
	line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	line_edit.text_submitted.connect(_on_submit)
	input_container.add_child(line_edit)

func _create_choice_buttons() -> void:
	for i in task_data.choices.size():
		var button = Button.new()
		button.text = task_data.choices[i]
		button.pressed.connect(_on_choice_selected.bind(i))
		input_container.add_child(button)

func _on_submit(_text: String = "") -> void:
	attempts += 1
	
	if validate():
		var time_taken = Time.get_ticks_msec() / 1000.0 - start_time
		
		# emits completed contente
		content_completed.emit({
			"task_id": task_data.task_id,
			"success": true,
			"attempts": attempts,
			"time": time_taken
		})
		
		if window:
			window.queue_free()
	else:
		feedback_label.text = task_data.error_message
		feedback_label.show()
		
		if task_data.max_attempts > 0 and attempts >= task_data.max_attempts:
			content_failed.emit()
			if window:
				window.queue_free()

func validate() -> bool:
	match task_data.task_type:
		TaskData.Type.TYPING:
			var input = input_container.get_child(0) as LineEdit
			if input:
				var user_answer = input.text.strip_edges().to_lower()
				var correct_answer = task_data.correct_answer.to_lower()
				return user_answer == correct_answer
		TaskData.Type.MULTIPLE_CHOICE:
			return true
	return false

func _on_choice_selected(index: int) -> void:
	if index == task_data.correct_choice_index:
		_on_submit(feedback_label.text)
	else:
		attempts += 1
		feedback_label.text = task_data.error_message
		feedback_label.show()
