extends AudioStreamPlayer

@onready var toast_sound = preload("res://assets/sounds/toaster.mp3")


# Play the given sound effect. sfx is a resource.
func play_sfx(sfx) -> void:
	$SFX.stream = sfx
	$SFX.play()
