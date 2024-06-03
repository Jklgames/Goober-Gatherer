class_name CreatureInstance

var nickName : String
var data : CreatureData

var ultCharge = 0
var skillFatigue : Array [int] = [0,0,0,0]

func _init(cdata : CreatureData):
	nickName = cdata.name
	data = cdata
	pass
