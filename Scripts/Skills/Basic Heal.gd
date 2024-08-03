extends Skill
class_name Basic_Heal

func possible_targets(user : Creature) -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []

	if !user.allied:
		targets.append_array(battle.enemies)
	else:
		targets.append_array(battle.allies)
	return targets


func _turn_logic(packet : ActionPacket):
	var battle = Battle.instance
	var user = packet.generalData["attacker"]
	var target = packet.generalData["target"]
	var healing : float = 0
	var userModStat = user.get_stat("maxhp")
	healing += userModStat*(power/100)
	print(user.instance.nickName+" healed "+str(round(healing))+" hp to "+target.instance.nickName)
	battle.battleLog.add_text_to_queue(user.instance.nickName+" healed "+str(round(healing))+" hp to "+target.instance.nickName)
	packet.generalData["damage"] = -healing
