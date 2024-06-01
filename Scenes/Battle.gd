extends Node3D
class_name Battle

@export var turnManager : TurnManager
var allies : Array = []
var enemies : Array = []
@export var allyFieldSlots : Array = []
@export var enemyFieldSlots : Array = [] 
@export var waves : Array = [] #array of partys
var wave : int = 0

var battleState : BattleState = BattleState.Init
func _ready():
	turnManager.Initialize()
	turnManager.turnList.Initialize()
	Initialize()
	pass
	
func Initialize():
	InitAllies()
	InitEnemies()
	pass
	
func InitAllies():
	var playerData : PlayerData = load("res://Party_Data.gd")
	for i in range(min(3,playerData.party.size())):
		var instance : CreatureInstance = playerData.party.creatures[i]
		var char : Creature = instance.data.creatureScene.instantiate()
		add_child(char)
		char.SetInstance(instance)
		char.position = allyFieldSlots[i].position
	pass
	
func InitEnemies():
	for i in range(min(3,waves[0].size())):
		var char = waves[0].creatures[i].instatiate
		add_child(char)
		char.position = enemyFieldSlots[i].position
	pass
	
enum BattleState { Init, Idle, TurnHandling, Win, Lose}
