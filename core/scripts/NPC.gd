extends CharacterBody2D


@export var idle_anim: String = "idle"
@export var center_pos: Node

const map_player_dir_to_NPC_dir = {"left": "right", "right": "left", "up": "forward", "down": "back"}


func _ready():
	idle()

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
