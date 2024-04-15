extends CharacterBody2D

@export var maxSpeed = 200
@export var acceleration = 1000
@export var friction = 20000

@onready var axis = Vector2.ZERO
@onready var sprite_2d = $Sprite2D

func _physics_process(delta):
	move(delta)
	
	
func get_input_axis():
	axis.x = int(Input.is_action_pressed("right"))	- int(Input.is_action_pressed("left"))	
	axis.y = int(Input.is_action_pressed("down"))	- int(Input.is_action_pressed("up"))	
	return axis.normalized()

func move(delta):
	axis = get_input_axis()
	
	if axis == Vector2.ZERO:
		apply_friction(friction * delta)
	else:
		apply_movement(axis * acceleration * delta)

	move_and_slide()

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
		

func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(maxSpeed)
	print(velocity)
	move_left()
	move_down()
	
func move_left():
	if velocity.x < 0:
		sprite_2d.animation = "left"
	elif velocity.x > 0:
		sprite_2d.animation = "right"
	
func move_down():
	if velocity.y < 0:
		sprite_2d.animation = "back"
	elif velocity.y > 0:
		sprite_2d.animation = "default"
		
		
