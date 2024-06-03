extends Resource
class_name Skill

@export var power : int

func possibleTargets() -> Array[Creature]:
	return []

func PreformSkill(User : Creature, Target : Creature):
	pass
