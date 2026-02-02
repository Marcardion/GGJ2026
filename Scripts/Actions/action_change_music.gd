extends BasicAction

@export var newMusic : AudioStream

func DoAction():
	Globals.changeMusic(newMusic)
