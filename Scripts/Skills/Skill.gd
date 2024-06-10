extends Resource
class_name Skill

@export var name : String = "Basic_Attack"
@export_multiline var description : String = "Placeholder description"
@export var power : float = 20	
@export var cooldown : int = 0

func PossibleTargets(user : Creature) -> Array[Creature]:
	
	return []
	
func PreformSkill(user : Creature, target : Creature):
	pass
