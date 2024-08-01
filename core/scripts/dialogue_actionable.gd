extends "res://scripts/base_actionable.gd"
## An actionable that triggers dialogue when it is interacted with.

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

## The NPC that will turn to look at the player upon interacting. Must have an attached NPC script.
## Leave blank if this actionable is an item.
@export var NPC: Node

## Whether or not each inventory item can be used on this actionable.
## Stored as an enum-bool pair.
@export var inv_item_interactable = {
	Inventory.Item.BUCKET: false, Inventory.Item.FISH: false, Inventory.Item.KEY: false, \
	Inventory.Item.LETTER: false, Inventory.Item.MAGNIFYING_GLASS: false, Inventory.Item.MARKERS: false, \
	Inventory.Item.MOP: false, Inventory.Item.PAPER: false, Inventory.Item.PEN: false, \
	Inventory.Item.STICK: false, Inventory.Item.TICKLER: false, Inventory.Item.WATER: false, \
	Inventory.Item.YARN: false }


func action(player) -> void:
	if NPC:
		NPC.look_at_player(player)
		
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	
	if NPC:
		await DialogueManager.dialogue_ended
		NPC.idle()
