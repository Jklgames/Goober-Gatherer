extends Control
class_name  TurnList

@export var turnManager : TurnManager
var turngraphics : Array[TurnGraphic] = []
@export var TurnGraphicPreFab : PackedScene 

# Called when the node enters the scene tree for the first time.
func Initialize():
	#turnManager = get_node("Turn_Manager")
	turnManager.turnOrderUpdated.connect(Update_Turns)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func New_Turn(turn : Turn) -> TurnGraphic:
	var newTG : TurnGraphic = TurnGraphicPreFab.instantiate()
	add_child(newTG)
	turngraphics.append(newTG)
	newTG.turn = turn
	newTG.turnName.text = turn.name
	return newTG

func Update_Turns():
	for i in range(turnManager.turns.size()):
		var turn = turnManager.turns[i]
		var graphic : TurnGraphic = turn.turnGraphic
		graphic.av.text = str(int(turn.actionValue))
		graphic.position.y = CalcGraphicPosition(graphic,i)
		pass
	pass

func CalcGraphicPosition(graphic :TurnGraphic,slot :int) -> float:
	const padding = 25
	var graphicSize= graphic.size.y
	return (graphicSize+padding)*slot

