extends Area2D

@export_file("*.tscn") var next_scene: String
@export var player_coords: Vector2 # the coords for the player to appear at in the next scene
@export var player_dir: String


func _on_body_entered(body):
	if next_scene:
		StageManager.changeStage(next_scene, player_coords, player_dir)
