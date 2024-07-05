extends Node


signal dialogue_started
signal dialogue_ended

var in_dev_console: bool = false
var in_dialogue: bool = false


# In some kind of UI menu that should disable player movement, including debugging and dialogue
func in_menu():
	return in_dev_console or in_dialogue
	
func get_states():
	return get_script().get_script_property_list().map(func(x): return str(x.name) + ": " + str(get(x.name)))
