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

func PreformSkill(user : Creature, target : Creature):
	var battle = Battle.instance

	var healing : float = 0
	var userModStat = user.Get_Stat("maxhp")
	healing += userModStat*(power/100)
	print(user.instance.nickName+" healed "+str(round(healing))+" hp to "+target.instance.nickName)
	battle.battleLog.AddTextToQueue(user.instance.nickName+" healed "+str(round(healing))+" hp to "+target.instance.nickName)
	var packet : ActionPacket = ActionPacket.new()
	packet.generalData["target"] = target
	packet.generalData["attacker"] = user
	packet.generalData["skill"] = self
	packet.generalData["damage"] = -healing
	battle.DealDamage(packet)
	pass
