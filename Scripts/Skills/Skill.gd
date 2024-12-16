extends Resource
class_name Skill

@export var name : String = "Basic_Attack"
@export_multiline var description : String = "Placeholder description"
@export var power : float = 20	
@export var cooldown : int = 0
@export var rawLogString : String 
@export var logReqestedValues : Array[String] 

func possible_targets(user : Creature) -> Array[Creature]:
	
	return []
	

func preform_skill(user : Creature, target : Creature):
	var battle = Battle.instance
	var packet : ActionPacket = ActionPacket.new(user,target,self,name)
	_turn_logic(packet)
	user.pre_skill_used.emit(packet)
	target.pre_attacked.emit(packet)
	
	if !rawLogString.is_empty():
		var pdata = packet.generalData
		var formattedValues = packet.getValues(logReqestedValues)
		var formattedString = rawLogString % formattedValues
		battle.battleLog.add_text_to_queue(formattedString)
		print(formattedString)
	pass
	Battle.instance.deal_damage(packet)
	
	user.post_skill_used.emit(packet)
	target.post_attacked.emit(packet)
	if cooldown != 0:
		user.instance.skillFatigue[user.instance.skills.find(self)] = cooldown


func  _turn_logic(packet : ActionPacket):
	pass
