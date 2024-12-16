extends Status
class_name DOT

@export var damage : float = 10
@export var persentageHP : bool = false #If true, damage is a persentage of current HP
@export var rawLogStringOnProc : String 
@export var logReqestedValues : Array[String] 

func turn_started():
	var damageToDeal = damage
	if persentageHP:
		damageToDeal = creature.get_stat("maxHP") * damage / 100
		pass
	var packet : ActionPacket = ActionPacket.new(applicant,creature,null,name)
	packet.generalData["damage"] = damageToDeal
	if rawLogStringOnProc.is_empty():
		Battle.instance.battleLog.add_text_to_queue(creature.instance.nickName+" suffered from " + name)
	else :
		var pdata = packet.generalData
		var formattedValues = packet.getValues(logReqestedValues)
		var formattedString = rawLogStringOnProc % formattedValues
		Battle.instance.battleLog.add_text_to_queue(formattedString)
	Battle.instance.deal_damage(packet)
	super()
	
	pass

func turn_ended():

	pass
