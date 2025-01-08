extends Resource
class_name Skill

@export var name : String = "Basic_Attack"
@export_multiline var description : String = "Placeholder description"
@export var power : float = 20	
@export var cooldown : int = 0
@export var rawLogString : String 
@export var logReqestedValues : Array[String] 
@export var endsTurn :bool = true 

@export var animateOnUser : bool
@export var userAnimation : PackedScene

@export var animateOnTarget : bool
@export var targetAnimation : PackedScene

func possible_targets(user : Creature) -> Array[Creature]:
	
	return []

func preform_skill(user : Creature, target : Creature):
	var packet : ActionPacket = ActionPacket.new(user,target,self,name)
	_turn_logic(packet)
	user.pre_skill_used.emit(packet)
	target.pre_attacked.emit(packet)
	
	if rawLogString.is_empty():
		rawLogString = "%s used %s on %s"
		logReqestedValues = ["attacker.instance.nickname","skill.name","target.instance.nickname"]
		pass
	packet.generalData["log"] = Battle.instance.battleLog.parse_text(rawLogString,logReqestedValues,packet)
	Battle.instance.process_action_packet(packet)
	user.post_skill_used.emit(packet)
	target.post_attacked.emit(packet)
	if cooldown != 0:
		user.instance.skillFatigue[user.instance.skills.find(self)] = cooldown
	if endsTurn:
		Battle.instance.turnManager.end_turn()

func _printLog():
	
	pass

func  _turn_logic(packet : ActionPacket):

	pass
