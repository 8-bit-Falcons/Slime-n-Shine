extends CharacterBody2D

@export var maxSpeed = 130
@export var acceleration = 1000
@export var friction = 20000

@onready var axis = Vector2.ZERO
@onready var dir_anim = $Direction/AnimationPlayer
@onready var actionable_finder = $Direction/ActionableFinder

var direction = "down"

func _physics_process(delta):
	if State.in_dialogue:
		dir_anim.stop()
	else:
		move(delta)
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action(self)
	
func get_input_axis():
	axis.x = int(Input.is_action_pressed("right"))	- int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("down"))	- int(Input.is_action_pressed("up"))
	return axis.normalized()

func move(delta):
	axis = get_input_axis()
	
	if axis == Vector2.ZERO:
		apply_friction(friction * delta)
		dir_anim.stop()
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

	if abs(velocity.x) >= abs(velocity.y):
		move_left()
	else:
		move_down()
	
func move_left():
	if velocity.x < 0:
		direction = "left"
		update_anim()
	elif velocity.x > 0:
		direction = "right"
		update_anim()
	
func move_down():
	if velocity.y < 0:
		direction = "up"
		update_anim()
	elif velocity.y > 0:
		direction = "down"
		update_anim()
		
func update_anim():
	dir_anim.play(direction)
