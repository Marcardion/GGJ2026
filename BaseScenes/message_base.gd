extends Control
class_name Message

@export var shouldLoadScene : bool = false
@export var messageText : String
@export var loadScenePath : String
@export var waitTime : float = 3


@onready var label = $Label
@onready var colorRect = $ColorRect

func _ready():
	if shouldLoadScene:
		showMessage()

func startMessage():
	Globals.disable_player_control()
	Globals.fadeOut()
	await get_tree().create_timer(Globals.fadeDuration).timeout
	self.visible = true
	showMessage()

func showMessage():
	label.text = messageText
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
		self.visible = false
		Globals.fadeIn()
	
