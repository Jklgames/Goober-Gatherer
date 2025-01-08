extends Skill
class_name BasicAttack

func possible_targets(user : Creature) -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []

	if user.allied:
		targets.append_array(battle.enemies)
	else:
		targets.append_array(battle.allies)
	return targets

func _turn_logic(packet : ActionPacket):
	var user = packet.generalData["attacker"]
	var target = packet.generalData["target"]
	
	var damageDealt : float = 0
	var userDmgStat = user.get_stat("attack")
	var targetDefStat = target.get_stat("defense")
	damageDealt += power*(userDmgStat/100)
	damageDealt = damageDealt/(targetDefStat/100)
	
	packet.generalData["damage"] = damageDealt
	
	if rawLogString.is_empty():
		rawLogString= "%s dealt %d damage to %s"
		logReqestedValues= ["attacker.instance.nickname","damage","target.instance.nickname"]
	pass
	if damageDealt > 0:
		target.ActionAnimationPlayer.play("Hurt")
		await target.ActionAnimationPlayer.animation_finished


