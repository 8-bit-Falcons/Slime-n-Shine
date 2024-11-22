extends Node2D

@export var dialogue_resource: DialogueResource

@onready var yarn: StaticBody2D = $Actionables/Yarn
@onready var key: AnimatedSprite2D = $Actionables/KeyHanger


# Called when the node enters the scene tree for the first time.
func _ready():
	if State.is_intro:
		Inventory.visible = true
		
		DialogueManager.show_dialogue_balloon(dialogue_resource, "intro")
		State.is_intro = false
	
	_on_actionable_states_modified()
	State.actionable_states_modified.connect(_on_actionable_states_modified)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_actionable_states_modified():
	if yarn and State.actionable_states_check_flag(State.ActionableStates.TOOK_YARN):
		yarn.queue_free()
	
	if State.actionable_states_check_flag(State.ActionableStates.KEY_FELL):
		key.play("taken")
		key.get_node("Actionable").queue_free()
