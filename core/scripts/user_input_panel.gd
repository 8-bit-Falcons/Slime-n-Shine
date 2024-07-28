extends CanvasLayer

@onready var line_edit = %LineEdit
@onready var label = %Label


signal input_submitted

# Called when the node enters the scene tree for the first time.
func _ready():
	line_edit.grab_focus()


# Return the player's inputted text
func get_input():
	return line_edit.text


func contains_letter():
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	return regex.search(str(line_edit.text))


func _on_line_edit_text_submitted(new_text):
	if contains_letter():
		input_submitted.emit()
	else:
		line_edit.clear()
		label.text = "Please enter at least one letter."
		label.modulate = Color(1, 0, 0, 1)
