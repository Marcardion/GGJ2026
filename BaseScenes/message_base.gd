extends Control

@export var shouldLoadScene : bool = false
@export var loadScenePath : String
@export var waitTime : float = 3

@onready var label = $Label
@onready var colorRect = $ColorRect

func _ready():
	if shouldLoadScene:
		await get_tree().create_timer(2)
		showMessage()
	else:
		Globals.disable_player_control()
		showMessage()

func showMessage():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "modulate", Color(label.modulate.r, label.modulate.g, label.modulate.b, 1), 1.5)
	await tween.finished
	await get_tree().create_timer(waitTime).timeout
	hideMessage()
func hideMessage():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "modulate", Color(label.modulate.r, label.modulate.g, label.modulate.b, 0), 1.5)
	await tween.finished
	if shouldLoadScene:
		Globals.change_scene(loadScenePath)
	else:
		tween = get_tree().create_tween().set_parallel(true)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(colorRect, "color", Color(colorRect.color.r, colorRect.color.g, colorRect.color.b, 0), 1.5)
		await tween.finished
		Globals.enable_player_control()
	
