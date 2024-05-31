extends Node
class_name TurnManager

@export var turnPrefab : PackedScene
var turns : Array = []
var turnList : TurnList

signal turnOrderUpdated

func Initialize():
	turnList = get_tree().root.get_node("Turn_List")

func Sort_Turns():
	turns.sort()
	turnOrderUpdated.emit()
	pass # Replace with function body.

func Add_Characher_Turn(creature : Creature):
	var newTurn = turnPrefab.instantiate()
	add_child(newTurn)
	newTurn.data["Type"] = "creature"
	newTurn.data["Creature"] = creature
	newTurn.actionValue = 10000/creature.Get_Stat("speed")
	newTurn.name = creature.nickname +"'s Turn"
	turns.append(newTurn)
	Sort_Turns()
	pass

func Add_Turn(turn : Turn):
	add_child(turn)
	turns.append(turn)
	turn.actionValue
	turn.turnGraphic = turnList.New_Turn(turn)
	Sort_Turns()
	pass

func End_Turn():
	var turn : Turn = turns[0]
	var newAV = 10000
	if (turn.data["Type"] == "Creature"):
		var creature = turn.data["Creature"]
		newAV = newAV/creature.Get_Stat("speed")
	else:
		newAV = turn.data["Speed"]
	turn.actionValue = newAV
	Sort_Turns()
	pass

func Advance_To_Next_Turn() -> Turn:
	var index = 0
	for turn in turns:
		move_child(turn,index)
		index += 1
	Sort_Turns()
	return turns[0]


