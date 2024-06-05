extends Skill
class_name Basic_Heal

func PossibleTargets(user : Creature) -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []

	if !user.allied:
		targets.append_array(battle.enemies)
	else:
		targets.append_array(battle.allies)
	return targets

func PreformSkill(User : Creature, Target : Creature):
	var healing : float = 0
	var userModStat = User.Get_Stat("maxhp")
	healing += power*(userModStat/100)
	print(User.instance.nickName+" healed "+str(healing)+" hp to "+Target.instance.nickName)
	Battle.instance.DealDamage(User,Target,-healing)
	pass
