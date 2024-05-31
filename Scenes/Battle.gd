extends Node3D
class_name Battle

@export var turnManager : TurnManager
var allies : Array = []
var enemies : Array = []
@export var Waves :  Array = [] 

func _ready():
	turnManager.Initialize()
	turnManager.turnList.Initialize()
	Initialize()
	pass
func Initialize():
	var playerData : PlayerData = load("res://Party_Data.gd")
	for i in range(3):
			playerData.party[i].instatiate

	pass
