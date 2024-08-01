extends Node


# Request to turn the player sprite to the given direction
# Options are "left", "right", "up", and "down"
signal request_player_turn(dir: String)

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
