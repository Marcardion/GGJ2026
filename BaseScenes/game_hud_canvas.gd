extends CanvasLayer

@export var startBlackScreen : bool = true
@onready var colorRect = $ColorRect

func _ready():
	Globals.gameHUD = self
	
	if startBlackScreen:
		colorRect.color.a = 1
		Globals.fadeIn()
	else:
		colorRect.color.a = 0
