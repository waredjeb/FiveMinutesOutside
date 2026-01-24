# data class for tasks types
extends Resource
class_name TaskData

#
enum Type {
	TYPING,
	MULTIPLE_CHOICE,
	CLICK_SEQUENCE,
	DRAG_DROP
}

@export var task_id: String
@export var task_type: Type = Type.TYPING

@export_group("Content")
@export_multiline var prompt: String
@export var hint: String = ""
@export var title: String = ""

@export_group("Typing Task")
@export var correct_answer: String = ""

@export_group("Multiple Choice")
@export var choices: Array[String] = []
@export var correct_choice_index: int = 0

@export_group("Feedback")
@export var error_message := "Try again"
@export var success_message := "Correct!"
@export var max_attempts := 0  # 0 = unlimited

@export_group("UI")
@export var submit_button_text := "Submit"
