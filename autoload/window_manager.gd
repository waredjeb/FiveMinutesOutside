# res://autoload/window_manager.gd
extends Node

const BASE_WINDOW = preload("res://scenes/base_window.tscn")
const TASK_CONTENT = preload("res://scenes/task_content.tscn")
const DIALOGUE_CONTENT = preload("res://scenes/dialogue_content.tscn")

var default_theme: WindowTheme
var canvas_layer: CanvasLayer

func _ready() -> void:
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)
	
	default_theme = load("res://scripts/windows/themes/default_theme.tres")

## Show a task window
func show_task(task_data: TaskData, theme: WindowTheme = null) -> BaseWindow:
	var window = BASE_WINDOW.instantiate()
	window.theme_resource = theme if theme else default_theme

	canvas_layer.add_child(window)
	await get_tree().process_frame

	window.set_title(task_data.task_id)

	var content = TASK_CONTENT.instantiate()
	window.set_content(content)
	content.setup(task_data)

	window.show_centered()

	return window

## Show a dialogue window
func show_dialogue(dialogue_data: DialogueData, theme: WindowTheme = null) -> BaseWindow:
	var window = BASE_WINDOW.instantiate()
	window.theme_resource = theme if theme else default_theme

	canvas_layer.add_child(window)
	await get_tree().process_frame

	window.set_title("")

	var content = DIALOGUE_CONTENT.instantiate()
	window.set_content(content)
	content.setup(dialogue_data)

	window.show_centered()

	return window
