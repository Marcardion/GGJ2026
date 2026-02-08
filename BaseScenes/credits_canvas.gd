extends CanvasLayer

@onready var exitButton = $UI/HBoxContainer/Button
@export var scenePath : String

func _ready():
	exitButton.grab_focus()

func _on_button_pressed():
	Globals.fadeOutLoadScene(scenePath)
