extends "res://scripts/base_actionable.gd"
## An actionable that changes frames when it is interacted with.


## The resource containing this actionable's current frame (an index into the array of frames)
@export var save_state: AnimActionableResource

@onready var sprite_2d = %Sprite2D


func _ready() -> void:
	# Check if the resource contains this tile's current frame
	if save_state.current_frame.has(position):
		sprite_2d.frame = save_state.frames[save_state.current_frame[position]]
	else:
		save_state.current_frame[position] = 0


func action(player) -> void:
	if save_state.current_frame[position] < save_state.frames.size() - 1:
		save_state.current_frame[position] += 1
		sprite_2d.frame = save_state.frames[save_state.current_frame[position]]
