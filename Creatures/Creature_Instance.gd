class_name CreatureInstance

var nickName : String
var data : CreatureData

func _init(cdata : CreatureData):
	nickName = cdata.name
	data = cdata
	pass
