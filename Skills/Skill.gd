extends Resource
class_name Skill

@export var name : String = "Basic_Attack"
@export_multiline var description : String = "Placeholder description"
@export var power : int = 20	

func PossibleTargets(User : Creature) -> Array[Creature]:
	
	return []
	
func PreformSkill(User : Creature, Target : Creature):
	pass
