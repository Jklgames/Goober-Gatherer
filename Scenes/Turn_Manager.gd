extends Node
class_name TurnManager

@export var turnPrefab : PackedScene
var turns : Array = []
@export var turnList : TurnList

signal turnOrderUpdated

func Initialize():
	#turnList = get_tree().root.get_node("Turn_List")
	pass

func Sort_Turns():
	turns.sort()
	turnOrderUpdated.emit()
	pass # Replace with function body.

func AddCreatureTurn(creature : Creature):
	var newTurn = turnPrefab.instantiate()
	add_child(newTurn)
	newTurn.data["Type"] = "creature"
	newTurn.data["Creature"] = creature
	newTurn.actionValue = 10000/creature.Get_Stat("speed")
	newTurn.name = creature.instance.nickName
	turns.append(newTurn)
	newTurn.turnGraphic = turnList.New_Turn(newTurn)
	Sort_Turns()
	pass

func AddTurn(turn : Turn):
	add_child(turn)
	turns.append(turn)
	turn.turnGraphic = turnList.New_Turn(turn)
	Sort_Turns()
	pass

func EndTurn():
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
	Sort_Turns()
	var turn : Turn = turns[0]
	var av : float = turn.actionValue
	for t :Turn in turns:
		t.actionValue -= av
	return turns[0]


