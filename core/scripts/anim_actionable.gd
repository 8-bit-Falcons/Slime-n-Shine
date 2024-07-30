extends "res://scripts/base_actionable.gd"
## An actionable that changes frames when it is interacted with.


## The frame IDs in each frame of the animation
@export var frames: Array[int]

@onready var sprite_2d = %Sprite2D

var i = 0  ## The index into the frames array


func action(player) -> void:
	if i < frames.size():
		sprite_2d.frame = frames[i]
		i += 1
