extends "res://scripts/base_actionable.gd"
## An actionable that changes frames when it is interacted with.

## The frame IDs for each frame of the animation
@export var frames: Array[int]

## The resource containing this actionable's current frame (an index into the array of frames)
@export var save_state: AnimActionableResource

## The State method that determines whether the actionable is currently enabled
@export var enabled_flag: String = ""


@onready var sprite_2d = %Sprite2D


func _ready() -> void:
	# Check if the resource contains this tile's current frame
	if save_state.current_frame.has(position):
		sprite_2d.frame = frames[save_state.current_frame[position]]
	else:
		save_state.current_frame[position] = 0


func action(player) -> void:
	if (not State.has_method(enabled_flag)) or State.call(enabled_flag):
		if save_state.current_frame[position] < frames.size() - 1:
			save_state.current_frame[position] += 1
			sprite_2d.frame = frames[save_state.current_frame[position]]
			
			if save_state.current_frame.values().all(func(x): return x == frames.size() - 1):
				save_state.all_actions_complete = true
		Global.animated_actionable_interacted_with.emit()
