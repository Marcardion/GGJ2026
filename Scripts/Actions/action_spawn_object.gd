extends BasicAction

@export var sceneToSpawn : PackedScene
@export var spawnNode : Node3D

func DoAction():
	var newscene = sceneToSpawn.instantiate()
	newscene.transform = spawnNode.transform
	get_tree().root.add_child(newscene)
