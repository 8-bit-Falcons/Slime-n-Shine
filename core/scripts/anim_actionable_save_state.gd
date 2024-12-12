class_name AnimActionableResource
extends Resource


## A dict containing the current frame of every tile, stored as position-frame pairs
@export var current_frame = {}

## Whether or not the actionable has reached the last frame of its animation
@export var all_actions_complete: bool = false

func are_all_actions_complete() -> bool:
	return all_actions_complete
