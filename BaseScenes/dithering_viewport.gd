extends SubViewportContainer

@onready var viewport = $SubViewport

func _ready():
	resizeWindow()
	get_viewport().size_changed.connect(resizeWindow)
	

func resizeWindow():
	viewport.size = get_viewport().size
