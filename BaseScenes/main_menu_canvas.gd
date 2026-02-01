extends CanvasLayer

@onready var colorRect = $ColorRect
@onready var UI = $UI
@onready var startButton = $UI/VBoxContainer/StartGameButton

func _ready():
	startButton.grab_focus()

func _on_start_game_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	UI.visible = false
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(colorRect, "color", Color(colorRect.color.r, colorRect.color.g, colorRect.color.b, 0), 1.2)
	await tween.finished
	
	colorRect.visible = false
	Globals.enable_player_control()

func _on_end_game_button_pressed():
	get_tree().quit()
