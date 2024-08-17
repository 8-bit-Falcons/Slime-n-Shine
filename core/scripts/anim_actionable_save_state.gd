class_name AnimActionableResource
extends Resource

## The frame IDs in each frame of the animation
@export var frames: Array[int]
## A dict containing the current frame of every tile, stored as position-frame pairs
@export var current_frame = {}

func are_all_actions_complete() -> bool:
	return current_frame and current_frame.values().all(func(x): return x == frames.size() - 1)
