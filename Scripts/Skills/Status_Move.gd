extends Skill
class_name StatusMove

@export var status : StatusType
@export var applicationChance : float = 100 #Out Of 100
@export var damaging : bool = false
@export var targetsAllies : bool = false

@export var failedLogString : String 
@export var failedLogReqestedValues : Array[String] 

func possible_targets(user : Creature) -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []

	if user.allied != targetsAllies:
		targets.append_array(battle.enemies)
	else:
		targets.append_array(battle.allies)

	for target in targets:
		if !status.stackable:
			if target.statuses.any(func(x): return x.type == status):
				targets.erase(target)


	return targets

func preform_skill(user : Creature, target : Creature):
	super(user,target)
	
	pass

func _turn_logic(packet : ActionPacket):
	var user = packet.generalData["attacker"]
	var target = packet.generalData["target"]
	if damaging:
		var damageDealt : float = 0
		var userDmgStat = user.get_stat("attack")
		var targetDefStat = target.get_stat("defense")
		damageDealt += power*(userDmgStat/100)
		damageDealt = damageDealt/(targetDefStat/100)
		if rawLogString.is_empty():
			rawLogString= "%s dealt %d damage to %s"
			logReqestedValues= ["attacker.instance.nickname","damage","target.instance.nickname"]
		packet.generalData["damage"] = damageDealt
		pass
	else:
		packet.generalData["damage"] = 0
		pass
	
	if (randf_range(0,100) < applicationChance):
		packet.generalData["status"] = status
		if rawLogString.is_empty():
			rawLogString = "%s inflicted %s on %s"
			logReqestedValues = ["attacker.instance.nickname","skill.status.name","target.instance.nickname"]
		pass
	elif !damaging:
		if failedLogReqestedValues.is_empty():
			rawLogString = "%s failed to inflict %s on %s"
			logReqestedValues = ["attacker.instance.nickname","skill.status.name","target.instance.nickname"]
		pass
	
	
	pass
