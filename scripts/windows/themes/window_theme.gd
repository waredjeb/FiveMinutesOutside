# e that stores all visual configuration for windows.
extends Resource
class_name WindowTheme

## TODO: figure out if this is what I actually want
## But idea is that this should control the style of the window
@export_group("Frame")
@export var frame_texture: Texture2D
@export var frame_margin_left := 5
@export var frame_margin_right := 5
@export var frame_margin_top := 5
@export var frame_margin_bottom := 5

@export_group("Title Bar")
@export var title_bar_texture: Texture2D
@export var title_bar_height := 32
@export var title_font: Font
@export var title_color := Color.WHITE
@export var title_alignment := HORIZONTAL_ALIGNMENT_CENTER

@export_group("Content Area")
@export var content_background: Texture2D
@export var content_padding := 6
@export var body_font: Font
@export var body_text_color := Color.BLACK

@export_group("Buttons")
@export var close_button_normal: Texture2D
@export var close_button_hover: Texture2D
@export var close_button_pressed: Texture2D
@export var action_button_normal: Texture2D
@export var action_button_hover: Texture2D
@export var action_button_pressed: Texture2D
@export var button_font: Font

@export_group("Layout")
@export var default_width := 500
@export var min_height := 150
@export var max_height := 600
@export var snap_to_grid := 2

@export_group("Audio")
@export var open_sound: AudioStream
@export var close_sound: AudioStream
@export var button_sound: AudioStream
@export var success_sound: AudioStream
@export var error_sound: AudioStream

@export_group("Animation")
@export var enable_open_animation := true
@export var enable_close_animation := true
@export var animation_duration := 0.3
