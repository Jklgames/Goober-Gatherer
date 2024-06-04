extends Node3D
class_name Creature

var data : CreatureData
var instance : CreatureInstance
var allied : bool
var hpbar : Bar

func Get_Stat(statName : String) -> float:
	var returnStat = data.get(statName.to_lower())
	#Augmented by passives and statuses
	return returnStat

func SetInstance(newinstance : CreatureInstance):
	instance = newinstance
	data = instance.data
	#Other Initialization stuff maybe
	pass


