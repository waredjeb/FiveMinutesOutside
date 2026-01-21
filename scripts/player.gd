extends CharacterBody2D

@export var speed: float = 400.0

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
