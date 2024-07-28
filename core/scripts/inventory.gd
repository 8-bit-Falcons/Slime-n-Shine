extends CanvasLayer

@export var dialogue_resource: DialogueResource

@onready var hbox = %HBoxContainer
@onready var panel = %Panel
@onready var item_label = %ItemLabel

const InventoryItem = preload("res://scenes/inventory_item.tscn")
enum Item {BUCKET, FISH, KEY, LETTER, MAGNIFYING_GLASS, MARKERS, MOP, PAPER, PEN, STICK, TICKLER, WATER, YARN}
# A list of items that can combine with another item, where the key is an item and the value is what it creates
const combos: Dictionary = {"pen": "letter", "paper": "letter", "stick": "tickler", "yarn": "tickler"}


# Called when the node enters the scene tree for the first time.
func _ready():
	panel.visible = false
	DialogueManager.got_dialogue.connect(_on_dialogue_manager_got_dialogue)
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	
	# TODO: remove this test code
	add_item(Item.FISH)
	add_item(Item.STICK)
	add_item(Item.MAGNIFYING_GLASS)
	add_item(Item.PAPER)
	add_item(Item.PEN)
	add_item(Item.YARN)
	#for item in Item:
		#add_item(Item[item])


# Add an item to the inventory
func add_item(item: Item):
	panel.visible = true
	
	var inventory_item = InventoryItem.instantiate()
	inventory_item.configure(get_item_name(item), hbox.get_child_count())
	hbox.add_child(inventory_item)
	inventory_item.toggled2.connect(_on_inventory_item_toggled)


# Remove an item from the inventory
func remove_item(item: Item):
	var inv_item = hbox.find_child(get_item_name(item), false, false)
	if inv_item:
		inv_item.queue_free()
		if hbox.get_child_count() == 0:
			panel.visible = false


# Gets the string name of the given Item
# for use in file path and naming nodes
func get_item_name(item: Item):
	return Item.keys()[item].to_lower()


# Given an item index, find the item's name
# If no such item exists, return null
func get_item_index(item_name: String):
	var i = Item.keys().find(item_name.to_snake_case().to_upper())
	if i > -1:
		return i
	else:
		return null


# Returns a list of all selected inventory items
func selected():
	var selected_items = []
	for item in hbox.get_children():
		if item.button_pressed:
			selected_items.append(item)
	
	return selected_items


# Deselect all selected inventory items
func deselect_all():
	for item in selected():
		item.set_pressed(false)


# Format an item's name for use in the ItemLabel
func format_name(name: String):
	return "[right]%s[/right]" % name.capitalize()
	

func set_disabled(disabled: bool):
	for item in hbox.get_children():
		item.disabled = disabled


# Set the ItemLabel's text to the currently-selected item's name
func _on_inventory_item_toggled(item_name, toggled_on):
	if toggled_on:
		item_label.text = format_name(item_name)
	elif not selected():
		item_label.text = ""
	else:
		item_label.text = format_name(selected()[0].name)


func _on_dialogue_manager_got_dialogue(line: DialogueLine):
	set_disabled(true)
	item_label.visible = false
	

func _on_dialogue_manager_dialogue_ended(resource: DialogueResource):
	set_disabled(false)
	item_label.visible = true
