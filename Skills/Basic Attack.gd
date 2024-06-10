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
	var battle = Battle.instance

	var damageDealt : float = 0
	var userDmgStat = User.Get_Stat("attack")
	var targetDefStat = Target.Get_Stat("defense")
	damageDealt += power*(userDmgStat/100)
	damageDealt = damageDealt/(targetDefStat/100)
	print(User.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+Target.instance.nickName)
	battle.battleLog.AddTextToQueue(User.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+Target.instance.nickName)
	battle.DealDamage(User,Target,damageDealt)
	pass
