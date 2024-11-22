extends Node2D


@onready var stick: Sprite2D = $Stick


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_actionable_states_modified()
	State.actionable_states_modified.connect(_on_actionable_states_modified)


func _on_actionable_states_modified():
	if stick and State.actionable_states_check_flag(State.ActionableStates.TOOK_STICK):
		stick.queue_free()
