extends Node3D
class_name Battle

@export var turnManager : TurnManager
var allies : Array[Creature] = []
var enemies : Array[Creature] = []
@export var allyFieldSlots : Array[Node] = []
@export var enemyFieldSlots : Array[Node] = [] 

@export var waves : Array[Party] = [] 
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
	ChanceBattleState(BattleState.Idle)
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
		parentSlot = allyFieldSlots[slot]
		pass
	else:
		parentSlot = enemyFieldSlots[slot]
		pass
	if parentSlot.get_child_count() > 0:
		for child in parentSlot.get_children():
			if (child is Creature):
				child.queue_free()
				pass
			pass
		pass
	pass

	var cNode : Creature = instance.data.creatureScene.instantiate()
	cNode.SetInstance(instance)
	parentSlot.add_child(cNode)
	cNode.position = Vector3.ZERO
	turnManager.AddCreatureTurn(cNode)
	pass


func _process(_delta):
	match battleState:
		BattleState.Idle:
			IdleingLoop()
			pass
		BattleState.TurnHandling:
			TurnHandlingLoop()
			pass
		_:
			pass
	pass

func IdleingLoop():
	turnManager.Advance_To_Next_Turn();
	ChanceBattleState(BattleState.TurnHandling)
	pass
func TurnHandlingLoop():
	if Input.is_action_just_pressed("generic_interact"):
		turnManager.EndTurn()
		pass
	pass

func ChanceBattleState(newState : BattleState):
	print ("Switching from: "+BattleState.keys()[battleState]+" to "+BattleState.keys()[newState])
	battleState = newState
	pass

enum BattleState { Init=0, Idle=1, TurnHandling=2, Win=3, Lose=4}
