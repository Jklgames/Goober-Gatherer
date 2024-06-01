
class_name CreatureInstance

var nickname : String
var data : CreatureData

func _init(cdata : CreatureData):
	nickname = cdata.name
	data = cdata
	pass
