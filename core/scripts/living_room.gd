extends Node2D

@export var dialogue_resource: DialogueResource


# Called when the node enters the scene tree for the first time.
func _ready():
	if State.is_intro:
		Inventory.visible = true
		
		DialogueManager.show_dialogue_balloon(dialogue_resource, "intro")
		State.is_intro = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
