extends CharacterBody2D

const DASH_LENGHT = 1500.0
const DASH_SPEED = 20.0
const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var DASHED:bool = false


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown: Timer = $Timer

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#Move
	var direction := Input.get_axis("move_left", "move_right")
	
	#Get direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#How in the world did I get this dashing working at all?!?!?
	if Input.is_action_just_pressed("dash") and cooldown.is_stopped():
		if direction > 0:
			velocity.x = move_toward(velocity.x+DASH_LENGHT, 0, DASH_SPEED)
			DASHED = true
			cooldown.start()
			print("Player dashed to the right")
		elif direction < 0:
			DASHED = true
			velocity.x = move_toward(velocity.x-DASH_LENGHT, 0, DASH_SPEED)
			cooldown.start()
			print("Player dashed to the left")
		else:
			DASHED = true
			velocity.x = move_toward(velocity.x+DASH_LENGHT, 0, DASH_SPEED)
			cooldown.start()
			print("Player hopefuly dashed in the corect direction")
			
			
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	#Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		elif DASHED == true:
			animated_sprite.play("dash")
			print("played dash")
			DASHED = false
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")


	move_and_slide()
