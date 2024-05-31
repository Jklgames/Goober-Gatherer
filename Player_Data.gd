extends Resource
class_name PlayerData

@export var party : Array = []


func Add_Creature(creature : Creature):
	party.append(creature)
	pass
func Remove_Creature(slot : int):
	party.remove_at(slot)
	pass
