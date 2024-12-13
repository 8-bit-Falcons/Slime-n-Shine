extends Node


# Request to turn the player sprite to the given direction
# Options are "left", "right", "up", and "down"
signal request_player_turn(dir: String)
signal animated_actionable_interacted_with

var IS_PG = true


const user_input = preload("res://scenes/user_input_panel.tscn")
const colors = {"banana": Color8(255, 248, 164), \
				"meowzers": Color8(251, 115, 255), \
				"you": Color8(204, 230, 255), \
				"bathroom_slimes": Color8(163, 230, 254), \
				"garden_slimes": Color8(255, 175, 176), \
				"kitchen_slimes": Color8(225, 204, 255), \
				"science_slimes": Color8(187, 254, 187), \
				"": Color8(255, 255, 255, 128)}
				
const slime_to_sprite = {"sticky": "bathroom_slimes", \
						"slorp": "bathroom_slimes", \
						"lint": "bathroom_slimes", \
						"martha": "kitchen_slimes", \
						"eggy": "kitchen_slimes", \
						"parfait": "kitchen_slimes", \
						"shore": "garden_slimes", \
						"mud pie": "garden_slimes", \
						"sherbet": "garden_slimes", \
						"dew": "science_slimes", \
						"minus": "science_slimes", \
						"lime": "science_slimes"}

var MC_name: String = "MC"


# Prompt the player for their name
func prompt_name():
	var input_node = user_input.instantiate()
	get_tree().get_root().add_child(input_node)
	await input_node.input_submitted
	
	var input = input_node.get_input()
	if input:
		MC_name = input
		
	input_node.queue_free()


# TODO: perhaps make State a Resource so this poorly-scalable function can be avoided.
# See: https://forum.godotengine.org/t/resetting-multiple-variables-on-game-restart/57401/3
func reset_game():
	MC_name = "MC"
	
	State.is_intro = true
	State.meowzers_quest = State.MeowzersQuest.NO_LETTER
	
	State.banana_quest = State.BananaQuest.SLEEPING
	State.saw_key = false
	
	State.chance_interaction = State.ChanceInteractionStates.NOT_SEEN
	
	State.study_quest = State.StudyQuest.PRE_QUEST
	State.dew_interactions = 0
	State.minus_interactions = 0
	State.lime_interactions = 0
	
	State.kitchen_quest = State.KitchenQuest.PRE_QUEST
	State.martha_interactions = 0
	State.eggy_interactions = 0
	State.parfait_interactions = 0
	
	State.garden_quest = State.GardenQuest.PRE_QUEST
	State.shore_post = 0
	State.mud_pie_interactions = 0
	State.sherbet_interactions = 0
	
	State.bathroom_quest = State.BathroomQuest.PRE_QUEST
	State.sticky_interactions = 0
	State.slorp_interactions = 0
	State.lint_interactions = 0
	
	State.actionable_states = 0
	
	State.cleaned_kitchen = false
	State.pulled_weeds = false

# TODO: double #'s for documentation comments
