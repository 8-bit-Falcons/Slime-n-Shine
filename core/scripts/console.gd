extends Window

@onready var input = %Input
@onready var output = %Output

var history = []
var index = -1
var methods = []


# Called when the node enters the scene tree for the first time.
func _ready():
	methods = get_script().get_script_method_list().map(func (x): return x.name)
	methods = methods.filter(func (x): return not x.begins_with("_"))


# Called during the processing step of the main loop.
func _process(delta):
	if Input.is_action_just_pressed("dev_console_toggle"):
		_toggle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	_on_history(event)
	_on_autocomplete(event)
	_run_command(event)


# Toggle the dev console.
func _toggle():
	input.text = ""
	visible = !visible
	State.in_dev_console = visible
	if visible:
		input.grab_focus()


# Handle autocompletion of method names.
func _on_autocomplete(event):
	if event.is_action_released("ui_text_completion_replace"):
		for method in methods:
			if method.begins_with(input.text):
				input.text = method
				input.caret_column = input.text.length()
				break


# Cycle through the previous commands on up or down arrow presses.
func _on_history(event):
	if event.is_action_released("ui_up") and history:
		index = clamp(index + 1, 0, history.size() - 1)
		input.text = history[history.size() - (index + 1)]
		input.caret_column = input.text.length()
	elif event.is_action_released("ui_down") and history:
		if index != -1:
			index = clamp(index - 1, 0, history.size() - 1)
			input.text = history[history.size() - (index + 1)]
			input.caret_column = input.text.length()


# Evaluate and, if it is parseable, execute the inputted expression.
func _run_command(event):
	if event.is_action_released("ui_text_completion_accept"):
		index = -1
		var expression = Expression.new()
		
		if input.text:
			history.append(input.text)
			output.text += "> " + input.text + "\n"
		
		var error = expression.parse(input.text)
		if error != OK:
			output.text += expression.get_error_text() + "\n"
			
		var result = expression.execute([], self)
		if expression.has_execute_failed():
			output.text += expression.get_error_text() + "\n"
		elif result:
			output.text += str(result) + "\n"
		
		input.text = ""
		output.scroll_vertical = output.get_line_count() - 1


# Display a list of commands
func help():
	return "COMMANDS:\n" + "\n".join(methods)


# Add an item to the inventory by name.
func add_inventory_item(item_name):
	var item = Inventory.get_item_index(item_name)
	if item:
		Inventory.add_item(item)
		return "Added " + item_name + " to inventory."
	else:
		return "ERROR: No such item exists."


# Remove an item from the inventory by name.
func remove_inventory_item(item_name):
	var item = Inventory.get_item_index(item_name)
	if item:
		Inventory.remove_item(item)
		return "Removed " + item_name + " from inventory."
	else:
		return "ERROR: No such item exists."


func get_states():
	return State.get_states()


func change_state(var_name: String, val):
	State.set(var_name, val)


func _on_close_requested():
	_toggle()
