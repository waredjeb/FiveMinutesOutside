# This should handle windows creation
# Also used for setting up themese, content and behaviour (like shaking, blurring etc)
extends PanelContainer
class_name BaseWindow

# signals 
signal closed
signal confirmed

# theme settings
@export var theme_resource: WindowTheme:
	set(value):
		theme_resource = value
		if is_node_ready(): #check if _ready() has been called. 
			_apply_theme()

# content
var content_plugin: WindowContent  # Instantiated dynamically

# extracting needed nodes
@onready var vbox: VBoxContainer = $VBoxContainer
@onready var title_bar: PanelContainer = %TitleBar
@onready var title_label: Label = %TitleLabel
@onready var close_btn: TextureButton = %CloseButton
@onready var content_container: MarginContainer = %ContentContainer
@onready var buttons_bar: HBoxContainer = %ButtonsBar
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer

func _ready() -> void:
	_apply_theme()
	_setup_base_signals()
	#TODO: fix sound
	_play_sound("open") 

## Load content into the window
func set_content(content: WindowContent) -> void:
	# Remove old content
	if content_plugin:
		#queue free --> safe destroying the node at the end of the frame
		content_plugin.queue_free()
	# Add new content
	content_plugin = content
	content_container.add_child(content_plugin)
	content_plugin.window = self  # Give content reference to window

	# connecting content signal to window
	content_plugin.content_completed.connect(_on_content_completed)
	# content has been somehow solved (correct submission for example)
	content_plugin.content_ready.emit()

func _on_content_completed(result: Dictionary) -> void:
	confirmed.emit()
	_play_sound("success")

## Theme
func _apply_theme() -> void:
	if not theme_resource or not is_node_ready():
		return
	
	var t = theme_resource
	
	# window size
	custom_minimum_size.x = t.default_width
	custom_minimum_size.y = t.min_height
	size.x = t.default_width
	
	# Frame
	if t.frame_texture:
		var style = StyleBoxTexture.new()
		style.texture = t.frame_texture
		style.texture_margin_left = t.frame_margin_left
		style.texture_margin_right = t.frame_margin_right
		style.texture_margin_top = t.frame_margin_top
		style.texture_margin_bottom = t.frame_margin_bottom
		add_theme_stylebox_override("panel", style)
	
	# Title bar
	if title_bar and t.title_bar_texture:
		var title_style = StyleBoxTexture.new()
		title_style.texture = t.title_bar_texture
		title_bar.add_theme_stylebox_override("panel", title_style)
		title_bar.custom_minimum_size.y = t.title_bar_height
	
	if title_label:
		if t.title_font:
			title_label.add_theme_font_override("font", t.title_font)
		title_label.add_theme_color_override("font_color", t.title_color)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Close button
	if close_btn:
		close_btn.texture_normal = t.close_button_normal
		close_btn.texture_hover = t.close_button_hover
		close_btn.texture_pressed = t.close_button_pressed
	
	# Content area
	if content_container:
		content_container.add_theme_constant_override("margin_left", t.content_padding)
		content_container.add_theme_constant_override("margin_right", t.content_padding)
		content_container.add_theme_constant_override("margin_top", t.content_padding)
		content_container.add_theme_constant_override("margin_bottom", t.content_padding)

func _setup_base_signals() -> void:
	if close_btn:
		close_btn.pressed.connect(_on_close)

func _on_close() -> void:
	_play_sound("close")
	closed.emit()
	
	if theme_resource and theme_resource.enable_close_animation:
		_animate_close()
	else:
		queue_free()

func _animate_close() -> void:
	#smooth animation for closing
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, theme_resource.animation_duration) #fading
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), theme_resource.animation_duration) #scaling down
	tween.tween_callback(queue_free)

func _play_sound(sound_type: String) -> void:
	if not theme_resource:
		return
	
	var sound: AudioStream
	match sound_type:
		"open": sound = theme_resource.open_sound
		"close": sound = theme_resource.close_sound
		"button": sound = theme_resource.button_sound
		"success": sound = theme_resource.success_sound
		"error": sound = theme_resource.error_sound
	
	if sound and audio_player:
		audio_player.stream = sound
		audio_player.play()

func set_title(text: String) -> void:
	if title_label:
		title_label.text = text

func close() -> void:
	_on_close()

func show_centered() -> void:
	show()
	position = (get_viewport_rect().size - size) / 2
	if theme_resource:
		position = position.snapped(Vector2.ONE * theme_resource.snap_to_grid)
	
	if theme_resource and theme_resource.enable_open_animation:
		_animate_open()

func _animate_open() -> void:
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, theme_resource.animation_duration)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, theme_resource.animation_duration)
