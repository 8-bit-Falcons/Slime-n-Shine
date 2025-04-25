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
	if save_state.current_frame.has(global_position):
		sprite_2d.frame = frames[save_state.current_frame[global_position]]
	else:
		save_state.current_frame[global_position] = 0


# HACK: is there a better way of doing this?
# disables collisions so you can interact with actionables whose collision shapes
# overlap with this tile. difficult to use signal because whether or not this is
# enabled could depend on multiple different types of variables (states,
# inventory items, etc.).
# this seems a bit inefficient.
func _process(delta: float) -> void:
	if State.has_method(enabled_flag) and save_state.current_frame[global_position] < frames.size() - 1:
		$CollisionShape2D.disabled = not State.call(enabled_flag)


func action(player) -> void:
	if (not State.has_method(enabled_flag)) or State.call(enabled_flag):
		if save_state.current_frame[global_position] < (frames.size() - 1):
			save_state.current_frame[global_position] += 1
			sprite_2d.frame = frames[save_state.current_frame[global_position]]
			
			if save_state.current_frame.values().all(func(x): return x == frames.size() - 1):
				save_state.all_actions_complete = true
		else:
			$CollisionShape2D.disabled = true
		Global.animated_actionable_interacted_with.emit()
