extends Node2D

@export var dialogue_resource: DialogueResource

@onready var yarn: StaticBody2D = $Actionables/Yarn
@onready var key: AnimatedSprite2D = $Actionables/KeyHanger
@onready var key_actionable: Area2D = $Actionables/KeyHanger/Actionable
@onready var key_action_area: CollisionShape2D = $Actionables/KeyHanger/Actionable/ActionArea
@onready var meowzers: CharacterBody2D = $Meowzers
@onready var banana: CharacterBody2D = $Banana

var chance_interaction = false


func _enter_tree() -> void:
	# Determine whether there will be a chance interaction
	if (not (State.is_intro
			or Inventory.has_item(Inventory.Item.MAGNIFYING_GLASS)
			or Inventory.has_item(Inventory.Item.KEY)
			or State.banana_quest == State.BananaQuest.SLEEPING)
			and State.chance_interaction == State.ChanceInteractionStates.NOT_SEEN):
		var rand = randi_range(1, 3)
		if rand == 1:
			chance_interaction = true
			State.chance_interaction = State.ChanceInteractionStates.OCCURRING


# Called when the node enters the scene tree for the first time.
func _ready():
	if State.is_intro:
		Inventory.visible = true
		
		DialogueManager.show_dialogue_balloon(dialogue_resource, "intro")
		State.is_intro = false
	
	_on_actionable_states_modified()
	State.actionable_states_modified.connect(_on_actionable_states_modified)
	State.banana_quest_progressed.connect(_on_banana_quest_progressed)


func _exit_tree() -> void:
	if State.chance_interaction == State.ChanceInteractionStates.OCCURRING:
		State.chance_interaction = State.ChanceInteractionStates.NOT_SEEN
	elif State.chance_interaction == State.ChanceInteractionStates.SEEN_AND_OCCURRING:
		State.chance_interaction = State.ChanceInteractionStates.SEEN


func _on_child_entered_tree(node: Node) -> void:
	if node.name == "Banana":
		_on_banana_quest_progressed(State.banana_quest, node)
	
	# Set up chance interaction between Banana and Meowzers
	if (chance_interaction and (node.name == "Banana" or node.name == "Meowzers")):
		node.get_node("Actionable").set("NPC", null)
		node.idle_anim = "chance_interaction"
		node.play_anim("chance_interaction")


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


func _on_banana_quest_progressed(state, b=banana):
	if state >= State.BananaQuest.AWAKE:
		b.idle_anim = "forward"
		b.idle()
		b.get_node("Actionable").set("NPC", b)


func _drop_key():
	State.actionable_states_add_flag(State.ActionableStates.KEY_FELL)
