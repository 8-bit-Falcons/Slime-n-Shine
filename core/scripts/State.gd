extends Node


const MESS_TILES_SAVE_STATE = preload("res://resources/mess_tiles_save_state.tres")
const WEEDS_TILES_SAVE_STATE = preload("res://resources/weeds_tiles_save_state.tres")


var in_dev_console: bool = false
var in_dialogue: bool = false

var is_intro: bool = true

enum MeowzersQuest {NO_LETTER, QUEST_STARTED}
var meowzers_quest = MeowzersQuest.NO_LETTER

enum BananaQuest {SLEEPING, AWAKE, ASKED_FOR_KEY, GOT_KEY}
var banana_quest = BananaQuest.SLEEPING
var saw_key = false

var cleaned_kitchen = false:
	get:
		return MESS_TILES_SAVE_STATE.are_all_actions_complete()
var pulled_weeds = false:
	get:
		return WEEDS_TILES_SAVE_STATE.are_all_actions_complete()


# In some kind of UI menu that should disable player movement, including dev console and dialogue.
func in_menu() -> bool:
	return in_dev_console or in_dialogue


# Return an array of property-value pairs, using every property in this script.
# Each item is a String formatted like so: "state: value"
func get_states():
	var properties = get_script().get_script_property_list().map(func(x): return x.name)
	return properties.filter(func(x): return not x.ends_with(".gd")).map(func(x): return x + ": " + str(get(x)))


## Whether the living room doors are enabled.
## Would be disabled in special sequences or cutscenes
func living_room_doors_enabled() -> bool:
	return meowzers_quest >= MeowzersQuest.QUEST_STARTED


## Whether it is currently possible to pull weeds
func are_weeds_pullable() -> bool:
	return true


## Whether it is currently possible to clean the kitchen
func is_kitchen_cleanable() -> bool:
	return true
