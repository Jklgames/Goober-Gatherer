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

func PreformSkill(user : Creature, target : Creature):
	var battle = Battle.instance

	var damageDealt : float = 0
	var userDmgStat = user.Get_Stat("attack")
	var targetDefStat = target.Get_Stat("defense")
	damageDealt += power*(userDmgStat/100)
	damageDealt = damageDealt/(targetDefStat/100)
	print(user.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickName)
	battle.battleLog.AddTextToQueue(user.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickName)
	battle.DealDamage(user,target,damageDealt)
	pass
