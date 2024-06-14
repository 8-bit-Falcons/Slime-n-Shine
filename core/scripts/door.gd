extends Area2D

@export_file("*.tscn") var next_scene: String


func _on_body_entered(body):
	if next_scene:
		StageManager.changeStage(next_scene)
