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
	DialogueManager.dialogue_started.connect(_on_dialogue_manager_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	
	add_item(Item.PAPER)
	add_item(Item.PEN)


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
		if item_label.text == format_name(get_item_name(item)):
			item_label.text = ""
		var id = inv_item.get_id()
		inv_item.free()
		
		if hbox.get_child_count() == 0:
			panel.visible = false
		else:
			# HACK: O(n) function; fix if used for larger-scale game
			# Bump down IDs of subsequent items
			for it in hbox.get_children():
				if it.get_id() > id:
					it.set_id(it.get_id() - 1)


# Return whether the player has the given item in their inventory
func has_item(item: Item) -> bool:
	var inv_item = hbox.find_child(get_item_name(item), false, false)
	if inv_item:
		return true
	else:
		return false


# Gets the string name of the given Item
# for use in file path and naming nodes
func get_item_name(item: Item):
	return Item.keys()[item].to_lower()


# Given an Item name, find the Item's enum value
# If no such Item exists, return null
func get_item_value(item_name: String):
	var i = Item.get(item_name.to_snake_case().to_upper())
	return i


# Returns a list of all selected inventory items
func selected():
	var selected_items = []
	for item in hbox.get_children():
		if item.button_pressed:
			selected_items.append(item)
	
	return selected_items


# Returns the first selected inventory item as an Item enum value
# If none are selected, returns -1
func selected_item():
	if selected():
		return get_item_value(selected()[0].name)
	else:
		return -1


# Deselect all selected inventory items
func deselect_all():
	for item in selected():
		item.set_pressed(false)


# Format an item's name for use in the ItemLabel
func format_name(name: String):
	return "[right]%s[/right]" % name.capitalize()


func get_num_items():
	return hbox.get_child_count()


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


func _on_dialogue_manager_dialogue_started(resource: DialogueResource):
	set_disabled(true)
	item_label.visible = false
	

func _on_dialogue_manager_dialogue_ended(resource: DialogueResource):
	set_disabled(false)
	item_label.visible = true
