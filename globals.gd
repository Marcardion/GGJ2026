extends Node

var player_enabled = true

func _input(event):
	if event.is_action_pressed("Escape"):
		return_to_menu()

func return_to_menu():
	change_scene("res://Levels/main_menu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func change_scene(scenepath):
	enable_player_control()
	get_tree().change_scene_to_file(scenepath)

func disable_player_control():
	player_enabled = false

func enable_player_control():
	player_enabled = true
