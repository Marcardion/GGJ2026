extends Interactable

@export var scenePath : String

func Interact():
	Globals.change_scene(scenePath)
