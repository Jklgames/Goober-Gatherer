extends Skill
class_name StatusMove

@export var status : Status
@export var applicationChance : float = 100 #Out Of 100


func PossibleTargets(user : Creature) -> Array[Creature]:
	var battle = Battle.instance
	var targets : Array[Creature] = []

	if user.allied:
		targets.append_array(battle.enemies)
	else:
		targets.append_array(battle.allies)
	return targets

func PreformSkill(user : Creature, target : Creature):
	var battle = Battle.instance
	var damageDealt : float = 0
	var userDmgStat = user.Get_Stat("attack")
	var targetDefStat = target.Get_Stat("defense")
	damageDealt += power*(userDmgStat/100)
	damageDealt = damageDealt/(targetDefStat/100)
	print(user.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickName)
	battle.battleLog.AddTextToQueue(user.instance.nickName+" dealt "+str(round(damageDealt))+" damage to "+target.instance.nickName)
	var packet :ActionPacket = ActionPacket.new(user,target,self)
	packet.generalData["damage"] = damageDealt
	if (randf_range(0,100) > applicationChance):
		packet.generalData["status"] = status
		battle.battleLog.AddTextToQueue(target.instance.nickName+" is inflicted with "+status.name)
		pass
	else:
		pass
	battle.DealDamage(packet)
	pass
