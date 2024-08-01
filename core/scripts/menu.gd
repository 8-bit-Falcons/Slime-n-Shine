extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/start_btn.grab_focus()
	Inventory.visible = false
	

func _on_start_btn_pressed():
	StageManager.changeStage(StageManager.LIVING_ROOM)
	Inventory.visible = true
	
func _on_credits_btn_pressed():
	StageManager.changeStage(StageManager.CREDITS)
	Inventory.visible = false
