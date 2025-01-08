extends Skill
class_name BasicHeal

func possible_targets(user : Creature) -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []

	if !user.allied:
		targets.append_array(battle.enemies)
	else:
		targets.append_array(battle.allies)
	return targets


func _turn_logic(packet : ActionPacket):
	var user = packet.generalData["attacker"]
	var healing : float = 0
	var userModStat = user.get_stat("maxhp")
	healing += userModStat*(power/100)
	packet.generalData["healing"] = healing
	
	if rawLogString.is_empty():
		rawLogString= "%s gained %d HP from %s"
		logReqestedValues= ["attacker.instance.nickname","healing","target.instance.nickname"]
	pass
