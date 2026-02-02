extends StaticBody3D
class_name Interactable

@onready var interactSFX = $InteractSFX
@export var actionArray : Array[BasicAction]
@export var singleUse : bool = true
var activated = false

func onHoverInteract():
	activateHighlight()

func Interact():
	interactSFX.play()
	for action in actionArray:
		action.DoAction()

func activateHighlight():
	pass

func _process(delta):
	if activated and singleUse:
		if !interactSFX.playing:
			queue_free()
