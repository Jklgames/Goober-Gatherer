extends Resource
class_name Skill

@export var name : String = "Basic_Attack"
@export_multiline var description : String = "Placeholder description"
@export var power : float = 20	
@export var cooldown : int = 0
@export var rawLogString : String 

func possible_targets(user : Creature) -> Array[Creature]:
	
	return []
	
func preform_skill(user : Creature, target : Creature):
	var packet : ActionPacket = ActionPacket.new(user,target,self)
	_turn_logic(packet)
	user.pre_skill_used.emit(packet)
	target.pre_attacked.emit(packet)
	Battle.instance.deal_damage(packet)
	user.post_skill_used.emit(packet)
	target.post_attacked.emit(packet)
	if cooldown != 0:
		user.instance.skillFatigue[user.instance.skills.find(self)] = cooldown

	pass

func  _turn_logic(packet : ActionPacket):
	
	pass
