extends Skill
class_name StatusMove

@export var status : Status
@export var applicationChance : float = 100 #Out Of 100
@export var damaging : bool = false
@export var targetsAllies : bool = false

var workingpacket : ActionPacket
func PossibleTargets(user : Creature) -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []

	if user.allied:
		targets.append_array(battle.enemies)
	else:
		targets.append_array(battle.allies)
	return targets

func PreformSkill(user : Creature, target : Creature):
	workingpacket = null
	super(user,target)
	Battle.instance.ApplyStatus(workingpacket)
	workingpacket = null
	pass

func _turn_logic(packet : ActionPacket):
	var battle = Battle.instance
	var user = packet.generalData["attacker"]
	var target = packet.generalData["target"]
	workingpacket = packet
	if damaging:
		var damageDealt : float = 0
		var userDmgStat = user.Get_Stat("attack")
		var targetDefStat = target.Get_Stat("defense")
		damageDealt += power*(userDmgStat/100)
		damageDealt = damageDealt/(targetDefStat/100)
		print(user.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickName)
		battle.battleLog.AddTextToQueue(user.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickName)
		packet.generalData["damage"] = damageDealt
		pass
	else:
		packet.generalData["damage"] = 0
		pass
	
	if (randf_range(0,100) > applicationChance):
		packet.generalData["status"] = status
		battle.battleLog.AddTextToQueue(target.instance.nickName+" is inflicted with "+status.name)
		pass
	elif !damaging:
		battle.battleLog.AddTextToQueue(status.name +" failed")
		pass
	
	
	pass
