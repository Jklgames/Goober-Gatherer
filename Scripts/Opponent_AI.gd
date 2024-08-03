extends Resource
class_name OpponentAI

@export var difficulty : int = 0

func TurnLogic():
		
	await _aI()
	pass

func _aI():
	await Battle.instance.get_tree().create_timer(0.5).timeout

	if difficulty == 0:
		var creature : Creature = Battle.instance.currentTurn.creature
		var usableSkillsIndexes :Array[int] = creature.instance.get_useable_skill_indexes()
		var skillIndex : int = usableSkillsIndexes[randi_range(0,usableSkillsIndexes.size()-1)]
		var skill : Skill = creature.instance.skills[skillIndex]
		var target : Creature = skill.possible_targets(creature)[randi_range(0,skill.possible_targets(creature).size()-1)]
		await Battle.instance.use_skill(creature,skillIndex,target)
		Battle.instance.turnManager.end_turn()
		pass
	pass

enum  Difficulty {Wild = 0,Starter=1 ,Easy=2 ,Trainer=3, Pro=4}
