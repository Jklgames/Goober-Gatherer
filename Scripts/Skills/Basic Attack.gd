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

func _turn_logic(packet : ActionPacket):
	var battle = Battle.instance
	var user = packet.generalData["attacker"]
	var target = packet.generalData["target"]
	
	var damageDealt : float = 0
	var userDmgStat = user.Get_Stat("attack")
	var targetDefStat = target.Get_Stat("defense")
	damageDealt += power*(userDmgStat/100)
	damageDealt = damageDealt/(targetDefStat/100)
	print(user.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickName)
	battle.battleLog.AddTextToQueue(user.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickName)
	packet.generalData["damage"] = damageDealt
	pass
