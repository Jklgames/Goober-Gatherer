extends Resource
class_name CreatureInstance

var nickName : String
var data : CreatureData

var ultCharge = 0
var skills : Array [Skill] = []
var skillFatigue : Array [int] = [0,0,0,0]
var hp : float

#var passives: Array = []
#var persistentSatuses : Array[PersistentStatus] = [] #to be added see Status

func GetUseableSkillsIndexes() -> Array[int]:
	var usableSkills : Array[int] = []
	for i in range(skills.size()):
		if skillFatigue[i] <= 0 && skills[i].PossibleTargets(Battle.instance.currentTurn.creature).size() > 0:
			usableSkills.append(i)
	return usableSkills

func _init(cdata : CreatureData):
	nickName = cdata.name
	data = cdata
	hp = cdata.maxhp
	skills.append_array(cdata.baseMoveSet) 
	pass
