# dialogue line class
extends Resource
class_name DialogueLine

@export var speaker_name: String = ""
@export_multiline var text: String = ""
@export var portrait: Texture2D #FIXME: do we want to be this fancy ?
@export var choices: Array[String] = []
