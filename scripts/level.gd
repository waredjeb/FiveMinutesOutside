# res://scripts/level.gd
extends Node2D

func _ready():
	print("Level _ready() started")
	
	var math_task = load("res://scripts/windows/data/tasks/math_quiz.tres")
	print("Task loaded: ", math_task)
	
	var custom_theme = load("res://scripts/windows/themes/default_theme.tres")
	print("Theme loaded: ", custom_theme)
	
	var intro = load("res://scripts/windows/data/dialogues/intro.tres")
	await WindowManager.show_dialogue(intro)
	
	#print("About to call WindowManager.show_task...")
	#var window = await WindowManager.show_task(math_task, custom_theme)
	#print("Window returned: ", window)
	#
	#window.confirmed.connect(_on_task_completed)
	#print("Level _ready() complete")

func _on_task_completed():
	return
	#print("Task done!")
	#
	## just for testing
