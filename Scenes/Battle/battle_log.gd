extends RichTextLabel
class_name BattleLog

var _baseString : String = "[color=#000000][font_size=30]"

var _queuedDialogs : Array[String] = []

var _currentlyDisplaying : bool = false 
var _dialogueSpeed : float = 0.0056

var _dialogIndex : int = 0

func parse_text(rawLog : String,requests : Array[String],packet : ActionPacket) -> String:
	var formattedValues = packet.getValues(requests)
	var formattedString = rawLog % formattedValues
	return formattedString

func add_text_to_queue(newLog : String):
	_queuedDialogs.append(newLog)
	if _currentlyDisplaying == false:
		display_queued_text()

func display_queued_text():
	_currentlyDisplaying = true
	_dialogIndex = 0
	while _queuedDialogs.size() != 0:
		if _dialogIndex < _queuedDialogs[0].length():
			text += _queuedDialogs[0][_dialogIndex]
			scroll_to_line(get_line_count()-1)
			_dialogIndex +=1
			await get_tree().create_timer(_dialogueSpeed).timeout
			pass
		else:
			_dialogIndex = 0
			text += "\n"
			print ("Log: "+ _queuedDialogs[0])
			_queuedDialogs.remove_at(0)
			pass
		pass
	
	_currentlyDisplaying = false
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	text = _baseString
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	pass
