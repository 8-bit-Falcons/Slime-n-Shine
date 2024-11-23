extends Button

# The ID (and thus the shortcut key) can be set from the editor for testing purposes
@export var _id: int = 0

signal toggled2(item_name, toggled_on)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Call here in case item is added through editor rather than code
	set_key(_id)


# Called when the button is toggled.
func _toggled(toggled_on):
	await get_tree().create_timer(0.1).timeout
	toggled2.emit(name, toggled_on)
	
	# Handle item combinations
	if toggled_on and Inventory.selected().size() > 1:
		var selected_items = Inventory.selected()
		# If the items can be combined, start a special dialogue
		if Inventory.combos.has_all([selected_items[0].name, selected_items[1].name]) and \
			Inventory.combos[selected_items[0].name] == Inventory.combos[selected_items[1].name]:
			DialogueManager.show_dialogue_balloon(Inventory.dialogue_resource, Inventory.combos[name])
		else:
			DialogueManager.show_dialogue_balloon(Inventory.dialogue_resource, "invalid_combo")
		
		# Toggle the second selected item off if it wasn't already toggled off in the dialogue
		await DialogueManager.dialogue_ended
		# TODO: this randomly throws an error sometimes?? interal error getting property button_pressed
		if is_instance_valid(self):
			set_pressed(false)


# Initialize the name and the key used to select this item.
func configure(name: String, id: int):
	set_name(name)
	set_button_icon(load("res://assets/inventory_sprites/%s.png" % name))
	set_id(id)
	

func set_id(id: int):
	if (id >= 0 and id < 9):
		_id = id
		set_key(_id)


func get_id():
	return _id


# Set the number key used to select this item.
# shift: how many keys to the right of the 1 key the desired key is
# e.g. if shift is 1, the 2 key will be associated with this item
func set_key(shift: int):
	var sc: Shortcut = Shortcut.new()
	var key: InputEventKey = InputEventKey.new()
	key.set_keycode(49 + shift)
	key.set_unicode(49 + shift)
	sc.events.append(key)
	self.set_shortcut(sc)
