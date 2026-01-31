extends CanvasLayer

@onready var colorRect = $ColorRect
@onready var UI = $UI

func _on_start_game_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	colorRect.visible = false #Add a cool tween instead
	UI.visible = false
	Globals.enable_player_control()


func _on_end_game_button_pressed():
	get_tree().quit()
