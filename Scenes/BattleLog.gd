extends Label
class_name BattleLog

var _queuedDialogs : Array[String] = []
var _currentlyDisplaying : bool = false 
var _dialogueSpeed : float = 0.0056

var _dialogIndex : int = 0

func AddTextToQueue(newLog : String):
	_queuedDialogs.append(newLog)
	if _currentlyDisplaying == false:
		DisplayQueuedText()

func DisplayQueuedText():
	_currentlyDisplaying = true
	_dialogIndex = 0
	
	while _queuedDialogs.size() != 0:

		if _dialogIndex < _queuedDialogs[0].length()-1:
			text += _queuedDialogs[0][_dialogIndex]
			_dialogIndex +=1
			await get_tree().create_timer(_dialogueSpeed).timeout
			pass
		else:
			_dialogIndex = 0
			text += "\n"
			_queuedDialogs.remove_at(0)
			pass
	
	_currentlyDisplaying = false
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	text = ""
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	pass
