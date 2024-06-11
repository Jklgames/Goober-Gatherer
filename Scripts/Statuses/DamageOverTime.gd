extends Status
class_name DOT

@export var damage : float = 10
@export var persentageHP : bool = false #If true, damage is a persentage of current HP

func turn_started():
	var damageToDeal = damage
	if persentageHP:
		damageToDeal = creature.Get_Stat("maxHP") * damage / 100
		pass
	var packet : ActionPacket = ActionPacket.new(creature,creature,null)
	Battle.instance.battleLog.AddTextToQueue(creature.instance.nickName+" suffered from " + name)
	packet.generalData["damage"] = damageToDeal
	Battle.instance.DealDamage(packet)
	
	if duration>0:
		duration -= 1
		if duration == 0:
			var i : int = creature.statuses.find(self)
			creature.statuses.remove_at(i)
			Battle.instance.battleLog.AddTextToQueue(creature.instance.nickName+" recovered from "+name)
			#remove status effect here
			pass
		pass
	
	pass

func turn_ended():

	pass



