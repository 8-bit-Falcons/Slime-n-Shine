extends "res://scripts/base_actionable.gd"

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var NPC: Node

func action(player) -> void:
	if NPC:
		NPC.look_at_player(player)
		
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	
	if NPC:
		await DialogueManager.dialogue_ended
		NPC.idle()
