extends CharacterBody2D


@export var idle_anim: String = "idle"

const map_player_dir_to_NPC_dir = {"left": "right", "right": "left", "up": "forward", "down": "back"}


func _ready():
	idle()
	
func look_at_player(player_dir: String):
	$AnimationPlayer.play(map_player_dir_to_NPC_dir[player_dir])
	
func idle():
	$AnimationPlayer.play(idle_anim)
