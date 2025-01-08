extends StatusType
class_name EffectOverTime


@export var value : float = 10
@export var healing : bool = false
@export var persentageHP : bool = false #If true, damage is a persentage of current HP
@export var rawLogStringOnProc : String 
@export var logReqestedValues : Array[String] 

func turn_started(effect : StatusEffect):
	var valueToDeal = value
	var creature : Creature = effect.creature
	var applicant : Creature = effect.applicant

	if persentageHP:
		valueToDeal = creature.get_stat("maxHP") * value / 100
		pass
	var packet : ActionPacket = ActionPacket.new(applicant,creature,null,name)

	var effectString = "healing" if healing else "damage"
	packet.generalData[effectString] = valueToDeal
	if rawLogStringOnProc.is_empty():

		rawLogStringOnProc = "%s took %d damage from %s"

		if healing:
			rawLogStringOnProc = "%s healed %d HP from %s"

		logReqestedValues = ["target.instance.nickname",effectString,"source"]
		pass
	packet.generalData["log"] = Battle.instance.battleLog.parse_text(rawLogStringOnProc,logReqestedValues,packet)

	Battle.instance.process_action_packet(packet)
	super(effect)
	pass