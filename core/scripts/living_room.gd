extends Node2D

@export var dialogue_resource: DialogueResource

@onready var yarn: StaticBody2D = $Actionables/Yarn
@onready var key: AnimatedSprite2D = $Actionables/KeyHanger
@onready var key_actionable: Area2D = $Actionables/KeyHanger/Actionable
@onready var key_action_area: CollisionShape2D = $Actionables/KeyHanger/Actionable/ActionArea
@onready var banana: CharacterBody2D = $Banana


# Called when the node enters the scene tree for the first time.
func _ready():
	if State.is_intro:
		Inventory.visible = true
		
		DialogueManager.show_dialogue_balloon(dialogue_resource, "intro")
		State.is_intro = false
	
	_on_actionable_states_modified()
	_on_banana_quest_progressed(State.banana_quest)
	State.actionable_states_modified.connect(_on_actionable_states_modified)
	State.banana_quest_progressed.connect(_on_banana_quest_progressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_actionable_states_modified():
	if is_instance_valid(yarn) and State.actionable_states_check_flag(State.ActionableStates.TOOK_YARN):
		yarn.queue_free()
	
	if State.actionable_states_check_flag(State.ActionableStates.KEY_FELL):
		# If the key fell, move the sprite to the floor
		if not State.actionable_states_check_flag(State.ActionableStates.TOOK_KEY):
			key.position.y = 112
			key.play("fallen")
			key_action_area.position.y = 0
		# If the key was taken, hide the key
		else:
			key.position.y = 48
			key.play("taken")
			if is_instance_valid(key_actionable):
				key_actionable.queue_free()


## Set up for being able to trigger magnifying glass scene
func _on_banana_quest_progressed(state):
	if state >= State.BananaQuest.AWAKE:
		banana.idle_anim = "forward"
		banana.idle()
		banana.get_node("Actionable").set("NPC", banana)


func _drop_key():
	State.actionable_states_add_flag(State.ActionableStates.KEY_FELL)
