# abstrct base class for all content types
extends Control
class_name WindowContent

## Abstract base for window content plugins --> just defining the interface --> let's override 
## TODO: Is this a good approach? Sounds too much object oriented --> figure out if there's another way

signal content_ready
signal content_completed(result: Dictionary)
signal content_failed

var window: BaseWindow  # Reference to parent window

## for overriding
func setup(_data: Resource) -> void:
	push_error("setup() not implemented in " + get_class())

func validate() -> bool:
	return true

func cleanup() -> void:
	pass
