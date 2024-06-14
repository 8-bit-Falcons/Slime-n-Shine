extends CanvasLayer

@onready var animations = $AnimationPlayer
@onready var black = $ColorRect

const LIVING_ROOM = "res://scenes/living_room.tscn"
const KITCHEN = "res://scenes/kitchen.tscn"
const GARDEN = "res://scenes/garden.tscn"
const STUDY = "res://scenes/study.tscn"
const BATHROOM = "res://scenes/bathroom.tscn"

func _ready():
	black.hide()

# Changes the scene
func changeStage(stage_path):
	# Fade in to black
	get_tree().paused = true
	black.show()
	animations.play("fade_in")
	await animations.animation_finished
	
	# Change the scene
	get_tree().change_scene_to_file(stage_path)
	
	# Fade out to scene
	animations.play("fade_out")
	await animations.animation_finished
	black.hide()
	get_tree().paused = false
