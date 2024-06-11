extends Resource
class_name Skill

@export var name : String = "Basic_Attack"
@export_multiline var description : String = "Placeholder description"
@export var power : float = 20	
@export var cooldown : int = 0

func PossibleTargets(user : Creature) -> Array[Creature]:
	
	return []
	
func PreformSkill(user : Creature, target : Creature):
	var packet : ActionPacket = ActionPacket.new(user,target,self)
	_turn_logic(packet)
	user.pre_skill_used.emit(packet)
	target.pre_attacked.emit(packet)
	Battle.instance.DealDamage(packet)
	user.post_skill_used.emit(packet)
	target.post_attacked.emit(packet)
	pass

func  _turn_logic(packet : ActionPacket):
	
	pass
