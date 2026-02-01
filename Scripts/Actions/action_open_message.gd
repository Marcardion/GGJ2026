extends BasicAction

@onready var message : Message = get_tree().get_first_node_in_group("message")
@export var actionMessageText : String
@export var actionMessageWaitTime : float

func DoAction():
	message.messageText = actionMessageText
	message.waitTime = actionMessageWaitTime
	message.startMessage()
