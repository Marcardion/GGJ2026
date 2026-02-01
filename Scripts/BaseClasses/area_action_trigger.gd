extends Node3D

@export var singleUse : bool = true
@export var actionArray : Array[BasicAction]
@onready var enterSFX = $EnterSFX
var activated = false

func _on_area_3d_body_entered(body):
	enterSFX.play()
	for action in actionArray:
		action.DoAction()
	activated = true

func _process(delta):
	if activated and singleUse:
		if !enterSFX.playing:
			queue_free()
