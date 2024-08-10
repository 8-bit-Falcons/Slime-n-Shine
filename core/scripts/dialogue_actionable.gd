extends "res://scripts/base_actionable.gd"
## An actionable that triggers dialogue when it is interacted with.

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

## The NPC that will turn to look at the player upon interacting. Must have an attached NPC script.
## Leave blank if this actionable is an item.
@export var NPC: Node


func action(player) -> void:
	if NPC:
		NPC.look_at_player(player)
	
	var selected_inv_items = Inventory.selected()
	if selected_inv_items:
		# TODO: remove
		#var selected_item_val = Inventory.get_item_value(selected_inv_items[0].name)
		#if usable_inv_items.has(selected_item_val):
			#DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start + "_use_item")
		#elif NPC:
			#DialogueManager.show_dialogue_balloon(dialogue_resource, "invalid")
		#else:
			#DialogueManager.show_dialogue_balloon(Inventory.dialogue_resource, "invalid_use")
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start + "_use_item")
	else:
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
		
	if NPC:
		await DialogueManager.dialogue_ended
		NPC.idle()
