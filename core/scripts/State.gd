extends Node


signal dialogue_started
signal dialogue_ended

var in_dialogue: bool = false:
	set(value):
		in_dialogue = value
		if value:
			dialogue_started.emit()
		else:
			dialogue_ended.emit()
