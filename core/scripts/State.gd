extends Node


const MESS_TILES_SAVE_STATE = preload("res://resources/mess_tiles_save_state.tres")
const WEEDS_TILES_SAVE_STATE = preload("res://resources/weeds_tiles_save_state.tres")


var in_dev_console: bool = false
var in_dialogue: bool = false

var is_intro: bool = true

enum NPCQuestStatus {NO_QUEST, NEW_QUEST, QUEST_IN_PROGRESS}

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


## Get the current quest state (new quest, in progress, or no quest) of the given NPC.
## npc_name: String beginning with a capital letter
func get_NPC_quest_status(npc_name: String):
	# TODO: implement all
	match npc_name:
		"Meowzers":
			if not is_intro and Inventory.has_item(Inventory.Item.LETTER):
				return NPCQuestStatus.NEW_QUEST
			elif meowzers_quest == MeowzersQuest.QUEST_STARTED:
				return NPCQuestStatus.QUEST_IN_PROGRESS
		"Banana":
			if banana_quest == BananaQuest.AWAKE and saw_key:
				return NPCQuestStatus.NEW_QUEST
			elif banana_quest == BananaQuest.ASKED_FOR_KEY:
				return NPCQuestStatus.QUEST_IN_PROGRESS
	return NPCQuestStatus.NO_QUEST


## Whether the living room doors are enabled.
## Would be disabled in special sequences or cutscenes
func living_room_doors_enabled() -> bool:
	return meowzers_quest >= MeowzersQuest.QUEST_STARTED


## Whether it is currently possible to pull weeds
func are_weeds_pullable() -> bool:
	return false


## Whether it is currently possible to clean the kitchen
func is_kitchen_cleanable() -> bool:
	return false
