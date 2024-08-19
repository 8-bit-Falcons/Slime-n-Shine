extends Area2D

@export_file("*.tscn") var next_scene: String
@export var player_coords: Vector2 # the coords for the player to appear at in the next scene
@export var player_dir: String


@export_group("Disabled")

## The State method that determines whether the door is currently disabled
@export var enabled_flag: String = ""

## The dialogue file containing text to display when attempting to use a disabled door
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "disabled_door"


func _on_body_entered(body):
	if ((not State.has_method(enabled_flag)) or State.call(enabled_flag)) and next_scene:
		StageManager.changeStage(next_scene, player_coords, player_dir)
	else:
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
