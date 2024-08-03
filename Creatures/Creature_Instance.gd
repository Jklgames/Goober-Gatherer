extends Resource
class_name CreatureInstance

var nickName : String
var data : CreatureData

var gooberCharge = 0
var skills : Array [Skill] = []
var skillFatigue : Array [int] = []
var hp : float

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
	return returnStat


func _init(cdata : CreatureData):
	nickName = cdata.name
	data = cdata
	hp = cdata.maxhp
	for skill in cdata.baseMoveSet:
		skills.append(skill.duplicate())
		skillFatigue.append(0)
	pass

