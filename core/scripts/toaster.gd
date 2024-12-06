extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	State.toaster_started.connect(_start_toaster)
	
	match State.toaster:
		State.ToasterStates.EMPTY:
			play("default")
		State.ToasterStates.BREAD:
			play("bread")
		State.ToasterStates.TOAST:
			play("toast")
		State.ToasterStates.BURNT_TOAST:
			play("burnt_toast")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _start_toaster(heat: State.ToasterStates):
	match heat:
		State.ToasterStates.BREAD:
			play("make_bread")
		State.ToasterStates.TOAST:
			play("make_toast")
		State.ToasterStates.BURNT_TOAST:
			play("make_burnt_toast")
