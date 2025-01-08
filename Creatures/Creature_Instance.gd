extends Resource
class_name CreatureInstance

var nickname : String
var data : CreatureData

var gooberCharge = 0
var skills : Array [Skill] = []
var skillFatigue : Array [int] = []
var hp : float

var IVs : Dictionary = {"maxhp" : 0,  "attack" : 0, "defense" : 0, "speed" : 0}

#var passives: Array = []
#var persistentSatuses : Array[PersistentStatus] = [] #to be added see Status

func get_useable_skill_indexes() -> Array[int]:
	var usableSkillsIndexes : Array[int] = []
	for i in range(skills.size()):
		if skillFatigue[i] <= 0 && skills[i].possible_targets(Battle.instance.currentTurn.creature).size() > 0:
			usableSkillsIndexes.append(i)
	return usableSkillsIndexes

func get_stat(statName : String) -> float:
	statName = statName.to_lower()
	var returnStat : float = data.get(statName)
	returnStat += round((IVs[statName])/2)
	return returnStat


func _init(cdata : CreatureData):
	nickname = cdata.name
	data = cdata
	_randomizeIVs()
	for skill in cdata.baseMoveSet:
		skills.append(skill.duplicate())
		skillFatigue.append(0)
	
	hp = get_stat("maxhp")
	print("\ncreature initalized")
	print(str(self))
	pass

func _randomizeIVs():
	for stat in IVs:
		IVs[stat] = randi_range(-30,30)
		pass
	pass

func get_IV_quality_string() -> String:
	var total : float = 0
	for stat in IVs:
		total += IVs[stat]
	var average : float = total / IVs.size()
	var quality : String = "terrible"
	if average < -15:
		quality = "terrible"
	elif average < 0:
		quality = "bad"
	elif average < 15:
		quality = "okay"
	elif average < 30:
		quality = "great"
	else:
		quality = "perfection"
	
	quality = "%s (%.2f)" % [quality, average]
	return quality

func _to_string() -> String:
	var string = "[CreatureInstance: %s\n" % nickname
	string += "Moves: "
	for skill in skills:
		string += "%s, " % skill.name
	string = string.trim_suffix(", ")
	string += "\nIVs: "
	for stat in IVs:
		string += "%s: %.2f, " % [stat,IVs[stat]]
	string = string.trim_suffix(", ")
	string += "\nIV quality: %s" % get_IV_quality_string()
	string += "\nData: %s]" % data.name
	return string
