extends Node


signal actionable_states_modified
signal banana_quest_progressed(state: int)
signal toaster_started(heat: ToasterStates)


const MESS_TILES_SAVE_STATE = preload("res://resources/mess_tiles_save_state.tres")
const WEEDS_TILES_SAVE_STATE = preload("res://resources/weeds_tiles_save_state.tres")


var in_dev_console: bool = false
var in_dialogue: bool = false

var is_intro: bool = true

enum NPCQuestStatus {NO_QUEST, NEW_QUEST, QUEST_IN_PROGRESS}

enum MeowzersQuest {NO_LETTER, QUEST_STARTED}
var meowzers_quest = MeowzersQuest.NO_LETTER
var asked_meowzers_for_key = false

enum BananaQuest {SLEEPING, AWAKE, ASKED_FOR_KEY, GOT_KEY}
var banana_quest = BananaQuest.SLEEPING:
	set(state):
		banana_quest = state
		banana_quest_progressed.emit(state)
var saw_key = false

enum ChanceInteractionStates {NOT_SEEN, OCCURRING, SEEN_AND_OCCURRING, SEEN}
var chance_interaction = ChanceInteractionStates.NOT_SEEN

enum StudyQuest {PRE_QUEST, QUEST_IN_PROGRESS, QUEST_COMPLETE}
var study_quest = StudyQuest.PRE_QUEST
var dew_interactions = 0
var minus_interactions = 0
var lime_interactions = 0

enum KitchenQuest {PRE_QUEST, QUEST_IN_PROGRESS, QUEST_COMPLETE}
var kitchen_quest = KitchenQuest.PRE_QUEST
var martha_interactions = 0
var eggy_interactions = 0
var parfait_interactions = 0

enum GardenQuest {PRE_QUEST, QUEST_IN_PROGRESS, QUEST_COMPLETE}
var garden_quest = GardenQuest.PRE_QUEST
var shore_post = 0
var mud_pie_interactions = 0
var sherbet_interactions = 0

enum BathroomQuest {PRE_QUEST, QUEST_IN_PROGRESS, QUEST_COMPLETE}
var bathroom_quest = BathroomQuest.PRE_QUEST
var sticky_interactions = 0
var slorp_interactions = 0
var lint_interactions = 0

enum ActionableStates {TOOK_YARN, TOOK_STICK, KEY_FELL, TOOK_KEY, DRAWER_UNLOCKED, DRAWER_OPEN, DRAWER_EMPTY, TOILET_EMPTY}
var actionable_states = 0

enum ToasterStates {EMPTY, BREAD, TOAST, BURNT_TOAST}
var toaster = ToasterStates.EMPTY

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
	match npc_name:
		"Meowzers":
			if ((not is_intro and Inventory.has_item(Inventory.Item.LETTER))
					or Inventory.has_item(Inventory.Item.KEY)):
				return NPCQuestStatus.NEW_QUEST
			elif meowzers_quest == MeowzersQuest.QUEST_STARTED:
				return NPCQuestStatus.QUEST_IN_PROGRESS
		"Banana":
			if (actionable_states_check_flag(ActionableStates.KEY_FELL)):
				return NPCQuestStatus.NO_QUEST
			elif ((banana_quest != BananaQuest.ASKED_FOR_KEY and saw_key)
					or (banana_quest == BananaQuest.ASKED_FOR_KEY
					and Inventory.has_item(Inventory.Item.MAGNIFYING_GLASS))):
				return NPCQuestStatus.NEW_QUEST
			elif banana_quest == BananaQuest.ASKED_FOR_KEY:
				return NPCQuestStatus.QUEST_IN_PROGRESS
		"Shore":
			if (garden_quest == GardenQuest.PRE_QUEST
					and kitchen_quest >= KitchenQuest.QUEST_IN_PROGRESS):
				return NPCQuestStatus.NEW_QUEST
			elif (garden_quest == GardenQuest.QUEST_IN_PROGRESS
					and pulled_weeds):
				return NPCQuestStatus.NEW_QUEST
			elif garden_quest == GardenQuest.QUEST_IN_PROGRESS:
				return NPCQuestStatus.QUEST_IN_PROGRESS
		"Martha":
			if kitchen_quest == KitchenQuest.PRE_QUEST:
				return NPCQuestStatus.NEW_QUEST
			elif (kitchen_quest == KitchenQuest.QUEST_IN_PROGRESS
					and cleaned_kitchen):
				return NPCQuestStatus.NEW_QUEST
			elif kitchen_quest == KitchenQuest.QUEST_IN_PROGRESS:
				return NPCQuestStatus.QUEST_IN_PROGRESS
		"Dew":
			if study_quest == StudyQuest.PRE_QUEST:
				return NPCQuestStatus.NEW_QUEST
			elif study_quest == StudyQuest.QUEST_IN_PROGRESS:
				return NPCQuestStatus.QUEST_IN_PROGRESS
		"Sticky":
			if (bathroom_quest == BathroomQuest.PRE_QUEST
					and kitchen_quest >= KitchenQuest.QUEST_IN_PROGRESS):
				return NPCQuestStatus.NEW_QUEST
			elif bathroom_quest == BathroomQuest.QUEST_IN_PROGRESS:
				return NPCQuestStatus.QUEST_IN_PROGRESS
	return NPCQuestStatus.NO_QUEST


## Whether the living room doors are enabled.
## Would be disabled in special sequences or cutscenes
func living_room_doors_enabled() -> bool:
	return meowzers_quest >= MeowzersQuest.QUEST_STARTED


## Whether it is currently possible to pull weeds
func are_weeds_pullable() -> bool:
	return garden_quest == GardenQuest.QUEST_IN_PROGRESS


## Whether it is currently possible to clean the kitchen
func is_kitchen_cleanable() -> bool:
	return Inventory.has_item(Inventory.Item.BUCKET) and Inventory.has_item(Inventory.Item.MOP)


func actionable_states_add_flag(flag):
	actionable_states |= (1 << flag)
	actionable_states_modified.emit()


func actionable_states_remove_flag(flag):
	actionable_states &= ~(1 << flag)
	actionable_states_modified.emit()


## Check whether the given flag is true. Must be a member of the ActionableStates enum.
func actionable_states_check_flag(flag: ActionableStates) -> bool:
	return actionable_states & (1 << flag)


## Check whether all flags in the given array are true.
func actionable_states_check_flags(flags: Array) -> bool:
	var flag_check = 0
	for flag in flags:
		flag_check |= (1 << flag)
	
	return actionable_states & flag_check == flag_check
