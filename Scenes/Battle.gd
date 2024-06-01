extends Node3D
class_name Battle

@export var turnManager : TurnManager
var allies : Array = []
var enemies : Array = []
@export var allyFieldSlots : Array = []
@export var enemyFieldSlots : Array = [] 
@export var waves : Array = [[]] 
var wave : int = 0

var battleState : BattleState = BattleState.Init
func _ready():
	turnManager.Initialize()
	turnManager.turnList.Initialize()
	Initialize()
	pass
	
func Initialize():
	InitAllies()
	pass
	
func InitAllies():
	var playerData : PlayerData = load("res://Party_Data.gd")
	for i in range(3):
		playerData.party[i].instatiate
	pass
	
func InitEnemies():
	for i in range(3):
		waves[0][i].instatiate
	pass
	
enum BattleState { Init, Idle, TurnHandling, Win, Lose}
