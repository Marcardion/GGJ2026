extends BasicAction

@export var nodesToDestroy : Array[Node]

func DoAction():
	for node in nodesToDestroy:
		node.queue_free()
