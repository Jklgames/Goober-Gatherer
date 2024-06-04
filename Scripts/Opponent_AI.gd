extends Resource
class_name OpponentAI

@export var difficulty : int = 0

func TurnLogic():
		
	await _aI()
	pass

func _aI():
	await Battle.instance.get_tree().create_timer(0.2).timeout

	if difficulty == 0:
		var creature : Creature = Battle.instance.currentTurn.creature
		var usableSkills :Array[int] = creature.instance.GetUseableSkillsIndexes()
		var skill : Skill = creature.instance.skills[usableSkills[randi_range(0,usableSkills.size()-1)]]
		var target : Creature = skill.PossibleTargets(creature)[randi_range(0,skill.PossibleTargets(creature).size()-1)]

		await skill.PreformSkill(creature,target)
		Battle.instance.turnManager.EndTurn()
		pass
	pass

enum  Difficulty {Wild = 0,Starter=1 ,Easy=2 ,Trainer=3, Pro=4}
