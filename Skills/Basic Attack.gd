extends Skill
class_name Basic_Attack

func PossibleTargets(user : Creature) -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []

	if user.allied:
		targets.append_array(battle.enemies)
	else:
		targets.append_array(battle.allies)
	return targets

func PreformSkill(User : Creature, Target : Creature):
	var damageDealt : float = 0
	var userDmgStat = User.Get_Stat("attack")
	var targetDefStat = Target.Get_Stat("defense")
	damageDealt += power*(userDmgStat/100)
	damageDealt = damageDealt/(targetDefStat/100)
	#actually do the damage here or something
	print(User.instance.nickName+" dealt "+str(damageDealt)+" damage to "+Target.instance.nickName)
	pass
