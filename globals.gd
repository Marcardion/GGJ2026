extends Node

var player_enabled = true
@onready var gameHUD : CanvasLayer
var fadeOutTween : Tween
var fadeDuration = 1.5

func _input(event):
	if event.is_action_pressed("Escape"):
		return_to_menu()

func changeMusic(newMusic : AudioStream):
	var musicPlayer : AudioStreamPlayer = gameHUD.get_child(1)
	musicPlayer.stop()
	musicPlayer.stream = newMusic
	musicPlayer.play()

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

func fadeOut():
	disable_player_control()
	if fadeOutTween:
		fadeOutTween.kill()
	var colorRect : ColorRect = gameHUD.get_child(0)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(colorRect, "color", Color(colorRect.color.r, colorRect.color.g, colorRect.color.b, 1), fadeDuration)
	fadeOutTween = tween
	
func fadeOutLoadScene(scenepath):
	fadeOut()
	fadeOutTween.finished.connect(change_scene.bind(scenepath))

func fadeIn():
	disable_player_control()
	if fadeOutTween:
		fadeOutTween.kill()
	var colorRect : ColorRect = gameHUD.get_child(0)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(colorRect, "color", Color(colorRect.color.r, colorRect.color.g, colorRect.color.b, 0), fadeDuration)
	fadeOutTween = tween
	await fadeOutTween.finished
	enable_player_control()
	
	
	
	
