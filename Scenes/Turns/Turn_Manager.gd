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
	var newTurn : Turn = turnPrefab.instantiate()
	add_child(newTurn)
	newTurn.type = newTurn.Type.Creature
	newTurn.creature = creature
	newTurn.actionValue = 10000/creature.Get_Stat("speed")
	newTurn.name = creature.instance.nickName
	turns.append(newTurn)
	newTurn.turnGraphic = turnList.New_Turn(newTurn)
	Sort_Turns()
	pass

func RemoveTurn(turn : Turn):
	var id = turns.find(turn)
	turns.remove_at(id)

	var turnGraphic = turn.turnGraphic
	var gid = turnList.turngraphics.find(turnGraphic)
	turnList.turngraphics.remove_at(gid)

	turn.queue_free()
	turnGraphic.queue_free()
	#Sort_Turns()

	pass

func GetCreatureTurn(creature : Creature) -> Turn:
	for t in turns:
		if t.type == t.Type.Creature && t.creature == creature:
			return t
	return null

func AddTurn(turn : Turn):
	add_child(turn)
	turns.append(turn)
	turn.turnGraphic = turnList.New_Turn(turn)
	Sort_Turns()
	pass

func EndTurn():
	var turn : Turn = turns[0]
	var newAV = 10000
	if (turn.type == turn.Type.Creature):
		var creature = turn.creature
		newAV = newAV/creature.Get_Stat("speed")
	else:
		newAV = turn.speed
	turn.actionValue = newAV
	var id = turns.find(turn,0)
	turns.remove_at(id)
	turns.append(turn)
	Sort_Turns()
	battle.ChangeBattleState(Battle.BattleState.Idle)
	pass

func Advance_To_Next_Turn() -> Turn:
	Sort_Turns()
	var turn : Turn = turns[0]
	var av : float = turn.actionValue
	for t :Turn in turns:
		t.actionValue = max(0,t.actionValue-av)
	Sort_Turns()
	return turns[0]


