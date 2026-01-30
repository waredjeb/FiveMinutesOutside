extends CharacterBody2D
@export var speed: float = 400.0
var nearby_interactable_area = null
signal interaction_available
signal interaction_unavailable
signal interaction_triggered

@onready var interaction_area = $InteractionArea

func _ready() -> void:
	interaction_area.area_entered.connect(_on_entered_area)
	interaction_area.area_exited.connect(_on_exited_area)

func _input(event):
	if (event.is_action_pressed("interact")):
		interaction_triggered.emit()
			
func _on_entered_area(area: Area2D) -> void:
	nearby_interactable_area = area
	if(area.has_method("interact")):
		interaction_triggered.connect(nearby_interactable_area.interact)
		interaction_available.emit()
	return
	
func _on_exited_area(area: Area2D) -> void:
	if(nearby_interactable_area):
		interaction_triggered.disconnect(nearby_interactable_area.interact)
		interaction_unavailable.emit()
	nearby_interactable_area = null	
	return
	
func _physics_process(_delta: float) -> void:
	# 1. Read input (simplified with Input.get_vector)
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	
	# 2. Set velocity
	velocity = input_dir * speed
	
	# 3. Move with physics
	move_and_slide()
	
	# 4. Update animation based on velocity
	update_animation(velocity)

func update_animation(dir: Vector2) -> void:
	if dir.is_zero_approx():
		$AnimatedSprite2D.stop()
		return
	
	# Horizontal movement takes priority
	if abs(dir.x) > abs(dir.y):
		$AnimatedSprite2D.play("walk_right")
		$AnimatedSprite2D.flip_h = dir.x < 0
	else:
		# Vertical movement
		if dir.y > 0:
			$AnimatedSprite2D.play("walk_down")
		else:
			$AnimatedSprite2D.play("walk_up")
