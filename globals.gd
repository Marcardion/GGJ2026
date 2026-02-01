extends Node

var player_enabled = true
@onready var gameHUD : CanvasLayer
var fadeInFinished : Signal
var fadeOutTween : Tween

func _input(event):
	if event.is_action_pressed("Escape"):
		return_to_menu()

func return_to_menu():
	change_scene("res://Levels/main_menu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func change_scene(scenepath):
	enable_player_control()
	get_tree().change_scene_to_file(scenepath)
	await get_tree().scene_changed
	gameHUD = get_tree().get_first_node_in_group("gamehud")

func disable_player_control():
	player_enabled = false

func enable_player_control():
	player_enabled = true

func fadeOut(scenepath):
	disable_player_control()
	if fadeOutTween:
		fadeOutTween.kill()
	var colorRect : ColorRect = gameHUD.get_child(0)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(colorRect, "color", Color(colorRect.color.r, colorRect.color.g, colorRect.color.b, 1), 1.5)
	fadeOutTween = tween
	fadeOutTween.finished.connect(change_scene.bind(scenepath))

func fadeIn():
	disable_player_control()
	if fadeOutTween:
		fadeOutTween.kill()
	var colorRect : ColorRect = gameHUD.get_child(0)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(colorRect, "color", Color(colorRect.color.r, colorRect.color.g, colorRect.color.b, 0), 1.5)
	fadeOutTween = tween
	await fadeOutTween.finished
	enable_player_control()
	fadeInFinished.emit()
	
	
	
	
