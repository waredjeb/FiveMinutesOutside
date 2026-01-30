extends Area2D
@export var dialogue : DialogueData
@export var window_theme : WindowTheme

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact() -> void:
	if(dialogue != null):
		WindowManager.show_dialogue(dialogue, window_theme)
	
