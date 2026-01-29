extends CanvasLayer

@onready var interaction_prompt = $Control/InteractPrompt
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.interaction_available.connect(show_prompt_label)
	player.interaction_unavailable.connect(hide_prompt_label)
	
func hide_prompt_label() -> void:
	interaction_prompt.visible = false
	return

func show_prompt_label() -> void:
	interaction_prompt.visible = true
	return
