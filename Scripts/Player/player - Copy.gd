extends CharacterBody2D

const DASH_SPEED = 100.0
const SPEED = 200.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown: Timer = $Timer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#Move
	var direction := Input.get_axis("move_left", "move_right")
	
	#Get direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
	
	
	#How in the world did I get this dashing working at all?!?!?
	
	if Input.is_action_just_pressed("dash") and cooldown.is_stopped():
		velocity.x = move_toward(velocity.x+1450, 0, DASH_SPEED)
		cooldown.start()
		print("timer started")
		
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
