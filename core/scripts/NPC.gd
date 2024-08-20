extends CharacterBody2D


## The name of this NPC's idle animation
@export var idle_anim: String = "idle"

## The node whose center represents this NPC's center. Used for Y Sort.
@export var center_pos: Node

## The StatusBubble indicating this NPC's quest status (new quest available, in quest, or no quest).
## Can be empty if this NPC does not have any quests
@export var status_bubble: AnimatedSprite2D

const map_player_dir_to_NPC_dir = {"left": "right", "right": "left", "up": "forward", "down": "back"}


func _ready():
	DialogueManager.dialogue_started.connect(_on_dialogue_manager_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	
	idle()
	update_status_bubble()


func look_at_player(player):
	var dx = center_pos.global_position.x - player.global_position.x
	var dy = center_pos.global_position.y - player.global_position.y
	var dir = ""
	if abs(dx) > abs(dy):
		if (dx > 0):
			dir = "left"
		else:
			dir = "right"
	else:
		if (dy > 0):
			dir = "back"
		else:
			dir = "forward"
	
	$AnimationPlayer.play(dir)


func idle():
	$AnimationPlayer.play(idle_anim)


func hide_status_bubble():
	if status_bubble:
		status_bubble.visible = false


func update_status_bubble():
	if status_bubble:
		match State.get_NPC_quest_status(name):
			State.NPCQuestStatus.NEW_QUEST:
				status_bubble.play("new_quest")
				status_bubble.visible = true
			State.NPCQuestStatus.QUEST_IN_PROGRESS:
				status_bubble.play("in_quest")
				status_bubble.visible = true
			_:
				hide_status_bubble()


func _on_dialogue_manager_dialogue_started(resource: DialogueResource):
	hide_status_bubble()


func _on_dialogue_manager_dialogue_ended(resource: DialogueResource):
	update_status_bubble()
