extends Resource
class_name PlayerData

@export var party : Party


func Add_Creature(creature : CreatureInstance):
	party.creatures.append(creature)
	pass
func Remove_Creature(slot : int):
	party.creatures.remove_at(slot)
	pass
