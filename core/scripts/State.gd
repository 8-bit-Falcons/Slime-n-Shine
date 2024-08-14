extends Node


var in_dev_console: bool = false
var in_dialogue: bool = false

var is_intro: bool = true
var in_tutorial: bool = true:
	get:
		return meowzers_quest < MeowzersQuest.QUEST_STARTED

enum MeowzersQuest {NO_LETTER, QUEST_STARTED}
var meowzers_quest = MeowzersQuest.NO_LETTER

enum BananaQuest {SLEEPING, AWAKE, ASKED_FOR_KEY, GOT_KEY}
var banana_quest = BananaQuest.SLEEPING
var saw_key = false

# In some kind of UI menu that should disable player movement, including dev console and dialogue.
func in_menu():
	return in_dev_console or in_dialogue


# Return an array of property-value pairs, using every property in this script.
# Each item is a String formatted like so: "state: value"
func get_states():
	var properties = get_script().get_script_property_list().map(func(x): return x.name)
	return properties.filter(func(x): return not x.ends_with(".gd")).map(func(x): return x + ": " + str(get(x)))
