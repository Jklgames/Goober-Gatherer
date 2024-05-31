extends Node
class_name TurnManager

@export var turnPrefab : PackedScene

func Add_Characher_Turn(creature : Creature):
	var newTurn = turnPrefab.instantiate()
	add_child(newTurn)
	newTurn.data["Type"] = "creature"
	newTurn.data["Creature"] = creature
	pass

func Add_Turn(turn : Turn):
	turn.instantiate()
	add_child(turn)
	pass
func endTurn
