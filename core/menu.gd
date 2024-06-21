extends Control

func _ready():
	$VBoxContainer/start_btn.grab_focus()
	Inventory.visible = false
	

func _on_start_btn_pressed():
	StageManager.changeStage(StageManager.LIVING_ROOM)
	Inventory.visible = true
