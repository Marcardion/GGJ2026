extends Interactable

@export var scenePath : String

func Interact():
	Globals.fadeOutLoadScene(scenePath)
