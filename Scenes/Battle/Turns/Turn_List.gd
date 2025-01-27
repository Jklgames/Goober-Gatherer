extends Control
class_name  TurnList

@export var turnManager : TurnManager
var turngraphics : Array[TurnGraphic] = []
@export var TurnGraphicPreFab : PackedScene 

# Called when the node enters the scene tree for the first time.
func initialize():
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

func Update_Turns() -> void:
	#var turnPositionPairs : Dictionary = {}
	
	for i in range(turnManager.turns.size()):
		var turn : Turn = turnManager.turns[i]
		var graphic : TurnGraphic = turn.turnGraphic
		graphic.av.text = str(int(turn.actionValue))
		#graphic.position.y = CalcGraphicPosition(graphic,i)
		graphic.moving = true
		graphic.targetHeight = CalcGraphicPosition(graphic,i)
		#turnPositionPairs[turn] = CalcGraphicPosition(graphic,i)
		pass
	pass

func move_turn_ui(turnPositionPairs : Dictionary):
	var notDone = true
	while notDone:
		notDone = false
		for turn : Turn in turnPositionPairs:
			var graphic : TurnGraphic = turn.turnGraphic
			var endPos : float = turnPositionPairs[turn]
			graphic.position.y = lerpf(graphic.position.y,endPos,0.05)
			if graphic.position.y != endPos:
				notDone = true
		await get_tree().process_frame
	
	for turn : Turn in turnPositionPairs:
		var graphic : TurnGraphic = turn.turnGraphic
		var endPos : float = turnPositionPairs[turn]
		graphic.position.y = endPos

	pass

func CalcGraphicPosition(graphic :TurnGraphic,slot :int) -> float:
	const padding = 0
	var graphicSize= graphic.size.y
	return (graphicSize+padding)*slot
