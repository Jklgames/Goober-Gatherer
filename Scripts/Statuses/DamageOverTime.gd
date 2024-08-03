extends Status
class_name DOT

@export var damage : float = 10
@export var persentageHP : bool = false #If true, damage is a persentage of current HP

func turn_started():
	var damageToDeal = damage
	if persentageHP:
		damageToDeal = creature.get_stat("maxHP") * damage / 100
		pass
	var packet : ActionPacket = ActionPacket.new(creature,creature,null)
	Battle.instance.battleLog.add_text_to_queue(creature.instance.nickName+" suffered from " + name)
	packet.generalData["damage"] = damageToDeal
	Battle.instance.deal_damage(packet)
	super()
	
	pass

func turn_ended():

	pass



