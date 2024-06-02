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
	var playerData : PlayerData = load("res://Player_Data.tres")
	var party :Party= playerData.party
	
	if !party.initalized:
		party.InitializeParty()
		pass
	
	for i in range(min(3,party.creatures.size())):
		var instance : CreatureInstance = party.creatures[i]
		SlotInCreature(true,instance,i)
		pass
	pass

func InitEnemies():
	var party : Party = waves[0]
	if !party.initalized:
		party.InitializeParty()
		pass

	for i in range(min(3,party.creatures.size())):
		var instance : CreatureInstance =  party.creatures[i]
		SlotInCreature(false,instance,i)
		pass
	pass

func SlotInCreature(isAlly:bool,instance:CreatureInstance,slot : int):
	if slot > 2 || slot < 0:
		print("Invalid Slot")
		return
	var parentSlot : Node
	if isAlly:
		parentSlot = get_node(allyFieldSlots[slot])
		pass
	else:
		parentSlot = get_node(enemyFieldSlots[slot])
		pass
	if parentSlot.get_child_count() > 0:
		for child in parentSlot.get_children():
			if (child is Creature):
				child.queue_free()

		
	
	var cNode : Creature = instance.data.creatureScene.instantiate()
	cNode.SetInstance(instance)
	parentSlot.add_child(cNode)
	cNode.position = Vector3.ZERO
	turnManager.AddCreatureTurn(cNode)
	pass

enum BattleState { Init, Idle, TurnHandling, Win, Lose}
