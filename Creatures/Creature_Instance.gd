class_name CreatureInstance

var nickName : String
var data : CreatureData

var ultCharge = 0
var skills : Array [Skill] = []
var skillFatigue : Array [int] = [0,0,0,0]
var hp : float

func GetUseableSkills() -> Array[Skill]:
	var usableSkills : Array[Skill] = []
	for i in range(skills.size()):
		print(Battle.instance.enemies.size())
		if skillFatigue[i] == 0 && skills[i].possibleTargets(Battle.instance.currentTurn.creature).size() > 0:
			usableSkills.append(skills[i])
	return usableSkills

func _init(cdata : CreatureData):
	nickName = cdata.name
	data = cdata
	hp = cdata.maxHP
	skills.append_array(cdata.baseMoveSet) 
	pass
