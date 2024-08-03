extends Node
class_name TurnManager
@export var battle : Battle
@export var turnPrefab : PackedScene
var turns : Array[Turn] = []
@export var turnList : TurnList

signal turnOrderUpdated

func initialize():
	#turnList = get_tree().root.get_node("Turn_List")
	pass

func sort_turns():
	turns.sort_custom(sort_by_action_value)
	turnOrderUpdated.emit()
	pass # Replace with function body.
	
func sort_by_action_value(a, b):
	return a.actionValue < b.actionValue

func add_creature_turn(creature : Creature):
	var newTurn : Turn = turnPrefab.instantiate()
	add_child(newTurn)
	newTurn.type = newTurn.Type.Creature
	newTurn.creature = creature
	newTurn.actionValue = 10000/creature.get_stat("speed")
	newTurn.name = creature.instance.nickName
	turns.append(newTurn)
	newTurn.turnGraphic = turnList.New_Turn(newTurn)
	sort_turns()
	pass

func remove_turn(turn : Turn):
	var id = turns.find(turn)
	turns.remove_at(id)

	var turnGraphic = turn.turnGraphic
	var gid = turnList.turngraphics.find(turnGraphic)
	turnList.turngraphics.remove_at(gid)

	turn.queue_free()
	turnGraphic.queue_free()
	#sort_turns()

	pass

func get_creature_turn(creature : Creature) -> Turn:
	for t in turns:
		if t.type == t.Type.Creature && t.creature == creature:
			return t
	return null

func add_turn(turn : Turn):
	add_child(turn)
	turns.append(turn)
	turn.turnGraphic = turnList.New_Turn(turn)
	sort_turns()
	pass

func end_turn():
	var turn : Turn = turns[0]
	var newAV = 10000
	if (turn.type == turn.Type.Creature):
		var creature = turn.creature
		newAV = newAV/creature.get_stat("speed")
	else:
		newAV = turn.speed
	turn.actionValue = newAV
	var id = turns.find(turn,0)
	turns.remove_at(id)
	turns.append(turn)
	sort_turns()
	battle.change_battle_state(Battle.BattleState.Idle)
	pass

func advance_to_next_turn() -> Turn:
	sort_turns()
	var turn : Turn = turns[0]
	var av : float = turn.actionValue
	for t :Turn in turns:
		t.actionValue = max(0,t.actionValue-av)
	sort_turns()
	return turns[0]


