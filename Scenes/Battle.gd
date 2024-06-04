extends Node3D
class_name Battle


@export var opponent : OpponentAI
@export var waves : Array[Party] = []
@export_group("Refrences")
@export var turnManager : TurnManager
@export var targetSelectionGraphic : Node3D
@export var currentTurnGraphic : Node3D
@export var HPbarPrefab : Node
@export var allyFieldSlots : Array[Node] = []
@export var enemyFieldSlots : Array[Node] = [] 

var allies : Array[Creature] = []
var enemies : Array[Creature] = []
var battleState : BattleState = BattleState.Init
var wave : int = 0
var turnCount : int = 0
var currentTurn : Turn 
var selectedTarget : Creature

static var instance : Battle

func _ready():
	instance = self
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
		var cinstance : CreatureInstance = party.creatures[i]
		SlotInCreature(true,cinstance,i)
		pass
	pass

func InitEnemies():
	var party : Party = waves[0]
	if !party.initalized:
		party.InitializeParty()
		pass
	
	for i in range(min(3,party.creatures.size())):
		var cinstance : CreatureInstance =  party.creatures[i]
		SlotInCreature(false,cinstance,i)
		pass
	pass

func SlotInCreature(isAlly:bool,cinstance:CreatureInstance,slot : int):
	if slot > 2 || slot < 0:
		print("Invalid Slot")
		return

	var creature : Creature = cinstance.data.creatureScene.instantiate()
	var parentSlot : Node
	if isAlly:
		parentSlot = allyFieldSlots[slot]
		allies.append(creature)
		pass
	else:
		parentSlot = enemyFieldSlots[slot]
		enemies.append(creature)
		pass
	
	if parentSlot.get_child_count() > 0:
		for child in parentSlot.get_children():
			if (child is Creature):
				child.queue_free()
				pass
			pass
		pass
	pass
	
	
	creature.SetInstance(cinstance)
	creature.allied = isAlly
	parentSlot.add_child(creature)
	creature.position = Vector3.ZERO
	turnManager.AddCreatureTurn(creature)
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
	SetCurrentTurn(turnManager.Advance_To_Next_Turn());
	ChanceBattleState(BattleState.TurnHandling)
	pass
	
func TurnHandlingLoop():

	if (currentTurn.type == currentTurn.Type.Creature && currentTurn.creature.allied):
		PlayerTurnLoop()


	pass

func PlayerTurnLoop():
		if Input.is_action_just_pressed("generic_interact"):
			await currentTurn.creature.instance.skills[selectedMove].PreformSkill(currentTurn.creature,selectedTarget)
			turnManager.EndTurn()
			return

		if (Input.is_action_just_pressed("ui_left")):
			selectedTargetIndex -= 1
			selectedTargetIndex %= possibleTargets.size()
			SetTarget(possibleTargets[selectedTargetIndex])
			pass
		elif (Input.is_action_just_pressed("ui_right")):
			selectedTargetIndex += 1
			selectedTargetIndex %= possibleTargets.size()
			SetTarget(possibleTargets[selectedTargetIndex])
			pass

var selectedMove : int
var possibleTargets : Array[Creature]
var selectedTargetIndex : int = 0

func SelectAndInitMove(slot : int):
	selectedMove = slot
	possibleTargets = currentTurn.creature.instance.skills[slot].PossibleTargets(currentTurn.creature)
	selectedTargetIndex = 0
	SetTarget(possibleTargets[0])
	pass


func ChanceBattleState(newState : BattleState):
	#print ("Switching from: "+BattleState.keys()[battleState]+" to "+BattleState.keys()[newState])
	battleState = newState
	match newState:
		BattleState.TurnHandling:
			if currentTurn.type == currentTurn.Type.Creature && currentTurn.creature.allied:
				var usableSkills : Array[int] = currentTurn.creature.instance.GetUseableSkillsIndexes()
				if usableSkills.size() > 0:
					SelectAndInitMove(usableSkills[0])
				pass
			elif currentTurn.type == currentTurn.Type.Creature && !currentTurn.creature.allied:
				opponent.TurnLogic()
				pass
			pass
	pass

func SetTarget(target : Creature):
	if (target == null):
		targetSelectionGraphic.hide()
		return
	selectedTarget = target
	targetSelectionGraphic.position = target.global_position
	targetSelectionGraphic.show()
	pass

func SetCurrentTurn(turn : Turn):
	currentTurn = turn
	if turn.type == turn.Type.Creature:
		currentTurnGraphic.show()
		currentTurnGraphic.position = turn.creature.global_position
		if turn.creature.allied:
			currentTurnGraphic.scale.x *=-1
			pass
		else:
			currentTurnGraphic.scale.x = abs(currentTurnGraphic.scale.x)
			pass
		pass
	else:
		currentTurnGraphic.hide()
	SetTarget(null)
	pass
enum BattleState { Init=0, Idle=1, TurnHandling=2, Win=3, Lose=4}
