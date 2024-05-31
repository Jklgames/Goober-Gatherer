extends Node3D
class_name Creature

var nickname : String
@export var data : CreatureData


func Get_Stat(statName : String) -> float:
	var returnStat = data.get(statName.to_lower())
	#Augment by passives and statuses
	return returnStat

