extends Panel
class_name  TurnList

var turnManager : TurnManager
var turngraphics : Array = []
@export var TurnGraphicPreFab : PackedScene 

# Called when the node enters the scene tree for the first time.
func Initialize():
	var turnManager = get_node("Turn_Manager")
	turnManager.turnOrderUpdated.connect(Update_Turns())
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func New_Turn(turn : Turn) -> TurnGraphic:
	var newTG : TurnGraphic = TurnGraphicPreFab.instantiate()
	add_child(newTG)
	turngraphics.append(newTG)
	newTG.turn = turn
	return newTG

func Update_Turns():
	var index : int = 0
	for turn : Turn in turnManager.turns:
		var graphic : TurnGraphic = turn.turnGraphic
		graphic.position.x = CalcGraphicPosition(graphic,index)
		index+1
		pass
	
	pass

func CalcGraphicPosition(graphic :TurnGraphic,slot :int) -> float:
	const padding= 50
	const graphicSize= 100
	return graphicSize+padding*slot
	pass
