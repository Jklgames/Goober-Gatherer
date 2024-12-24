extends Skill
class_name StatusMove

@export var status : Status
@export var applicationChance : float = 100 #Out Of 100
@export var damaging : bool = false
@export var targetsAllies : bool = false

@export var failedLogString : String 
@export var failedLogReqestedValues : Array[String] 

var workingpacket : ActionPacket
func possible_targets(user : Creature) -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []

	if user.allied != targetsAllies:
		targets.append_array(battle.enemies)
	else:
		targets.append_array(battle.allies)
	return targets

func preform_skill(user : Creature, target : Creature):
	workingpacket = null
	super(user,target)
	Battle.instance.apply_status(workingpacket)
	workingpacket = null
	pass

func _turn_logic(packet : ActionPacket):
	var battle = Battle.instance
	var user = packet.generalData["attacker"]
	var target = packet.generalData["target"]
	workingpacket = packet
	if damaging:
		var damageDealt : float = 0
		var userDmgStat = user.get_stat("attack")
		var targetDefStat = target.get_stat("defense")
		damageDealt += power*(userDmgStat/100)
		damageDealt = damageDealt/(targetDefStat/100)
		if rawLogString.is_empty():
			print(user.instance.nickname+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickname)
			battle.battleLog.add_text_to_queue(user.instance.nickname+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickname)
		packet.generalData["damage"] = damageDealt
		pass
	else:
		packet.generalData["damage"] = 0
		pass
	
	if (randf_range(0,100) < applicationChance):
		packet.generalData["status"] = status
		if rawLogString.is_empty():
			battle.battleLog.add_text_to_queue(target.instance.nickname+" is inflicted with "+status.name)
		pass
	elif !damaging:
		if failedLogReqestedValues.is_empty():
			battle.battleLog.add_text_to_queue(status.name +" failed")
		
		pass
	
	
	pass
