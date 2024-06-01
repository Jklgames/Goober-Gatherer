extends Node3D
class_name Creature

@export var dataPath : String
@onready var data : CreatureData = load(dataPath)
var instance : CreatureInstance

func Get_Stat(statName : String) -> float:
	var returnStat = data.get(statName.to_lower())
	#Augmented by passives and statuses
	return returnStat

func SetInstance(newinstance : CreatureInstance):
	instance = newinstance
	#Other Initialization stuff maybe
	pass


