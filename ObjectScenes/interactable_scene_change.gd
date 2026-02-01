extends Interactable

@export var scenePath : String

func Interact():
	Globals.fadeOut(scenePath)
