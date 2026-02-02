extends BasicAction

@export var scenePath : String

func DoAction():
	Globals.fadeOutLoadScene(scenePath)
