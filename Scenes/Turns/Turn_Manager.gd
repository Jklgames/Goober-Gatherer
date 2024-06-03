extends Node
class_name TurnManager
@export var battle : Battle
@export var turnPrefab : PackedScene
var turns : Array[Turn] = []
@export var turnList : TurnList

signal turnOrderUpdated

func Initialize():
	#turnList = get_tree().root.get_node("Turn_List")
	pass

func Sort_Turns():
	turns.sort_custom(sortbyav)
	turnOrderUpdated.emit()
	pass # Replace with function body.
	
func sortbyav(a, b):
	return a.actionValue < b.actionValue

func AddCreatureTurn(creature : Creature):
	var newTurn = turnPrefab.instantiate()
	add_child(newTurn)
	newTurn.data["Type"] = "Creature"
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
	var id = turns.find(turn,0)
	turns.remove_at(id)
	turns.append(turn)
	Sort_Turns()
	battle.ChanceBattleState(Battle.BattleState.Idle)
	pass

func Advance_To_Next_Turn() -> Turn:
	Sort_Turns()
	var turn : Turn = turns[0]
	var av : float = turn.actionValue
	for t :Turn in turns:
		t.actionValue = max(0,t.actionValue-av)
	Sort_Turns()
	return turns[0]


