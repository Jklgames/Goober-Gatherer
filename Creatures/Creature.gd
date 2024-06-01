extends Node3D
class_name Creature

@export var nickname : String
@export var dataPath : String
@onready var data : CreatureData = load(dataPath)

func Get_Stat(statName : String) -> float:
	var returnStat = data.get(statName.to_lower())
	#Augment by passives and statuses
	return returnStat

