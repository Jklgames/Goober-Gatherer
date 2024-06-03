extends Skill
class_name Basic_Attack

func possibleTargets() -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []
	targets.append_array(battle.enemies)
	return targets

func PreformSkill(User : Creature, Target : Creature):
	var damageDealt : float = 0
	var userDmgStat = User.Get_Stat("damage")
	var targetDefStat = Target.Get_Stat("defense")
	damageDealt += power*(userDmgStat/100)
	damageDealt = damageDealt/(targetDefStat/100)
	#actually do the damage here or something
	pass
