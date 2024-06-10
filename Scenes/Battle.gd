extends Node3D
class_name Battle


@export var opponent : OpponentAI
@export var waves : Array[Party] = []
@export_group("Refrences")
@export var turnManager : TurnManager
@export var targetSelectionGraphic : Node3D
@export var currentTurnGraphic : Node3D
@export var hPBarPrefab : PackedScene
@export var allyFieldSlots : Array[Node] = []
@export var enemyFieldSlots : Array[Node] = [] 
@export var battleLog : BattleLog
@export var skillButtons : Array[Button]
@export var skillSelectionGraphic : Panel
var allies : Array[Creature] = []
var enemies : Array[Creature] = []
var battleState : BattleState = BattleState.Init
var wave : int = 0
var turnCount : int = 0
var currentTurn : Turn 
var selectedTarget : Creature

static var instance : Battle

func _ready():

	for id: int in Input.get_connected_joypads():
		InputMap.get_actions()
		

	for i in range(skillButtons.size()):
		skillButtons[i].connect("pressed",Callable(self,"SkillButtonPressed").bind(i))
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

	creature.SetInstance(cinstance)
	creature.allied = isAlly
	parentSlot.add_child(creature)
	creature.position = Vector3.ZERO
	turnManager.AddCreatureTurn(creature)
	#Add HP Bar
	var hpbar : Bar = hPBarPrefab.instantiate()
	creature.hpbar = hpbar
	creature.add_child(hpbar)
	hpbar.position = Vector3(0,1,0)
	hpbar.SetMax(creature.Get_Stat("maxhp"))
	hpbar.value = cinstance.hp
	hpbar.progressBar.value = hpbar.value
	pass
func RemoveCreature(creature : Creature):
	if creature.allied:
		allies.remove_at(allies.find(creature))
		pass
	else:
		enemies.remove_at(enemies.find(creature))
		pass
	var turn = turnManager.GetCreatureTurn(creature)
	turnManager.RemoveTurn(turn)
	creature.queue_free()
	

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
			await UseSkill(currentTurn.creature,selectedSkill,selectedTarget)
			return

		if (Input.is_action_just_pressed("general_down")):
			var nextSkill = (selectedSkill+1) % currentTurn.creature.instance.skills.size()
			SelectAndInitMove(nextSkill)
		elif (Input.is_action_just_pressed("general_up")):
			var nextSkill = (selectedSkill-1) % currentTurn.creature.instance.skills.size()
			SelectAndInitMove(nextSkill)

		if (Input.is_action_just_pressed("general_left")):
			selectedTargetIndex -= 1
			selectedTargetIndex %= possibleTargets.size()
			SetTarget(possibleTargets[selectedTargetIndex])
			pass
		elif (Input.is_action_just_pressed("general_right")):
			selectedTargetIndex += 1
			selectedTargetIndex %= possibleTargets.size()
			SetTarget(possibleTargets[selectedTargetIndex])
			pass

var selectedSkill : int
var possibleTargets : Array[Creature]
var selectedTargetIndex : int = 0

func SelectAndInitMove(slot : int):
	if currentTurn.creature.instance.skills.size() <= abs(slot):
		print("Invalid Slot")
		return
	if (slot <0):
		var skill : Skill = currentTurn.creature.instance.skills[slot]
		slot = currentTurn.creature.instance.skills.find(skill)
	
	

	skillSelectionGraphic.show()
	skillSelectionGraphic.global_position = skillButtons[slot].global_position

	selectedSkill = slot
	possibleTargets = currentTurn.creature.instance.skills[slot].PossibleTargets(currentTurn.creature)
	possibleTargets.sort_custom(sortbyXPos)
	selectedTargetIndex = 0
	SetTarget(possibleTargets[0])
	pass

func sortbyXPos(a : Node3D, b : Node3D):
	return a.global_position.x < b.global_position.x

func ChanceBattleState(newState : BattleState):
	#print ("Switching from: "+BattleState.keys()[battleState]+" to "+BattleState.keys()[newState])
	battleState = newState
	match newState:
		BattleState.Idle:
			if allies.size() == 0:
				ChanceBattleState(BattleState.Lose)
			elif enemies.size() == 0:
				ChanceBattleState(BattleState.Win)
				pass
			pass
		BattleState.TurnHandling:
			turnhandler()
			pass
		BattleState.Win:
			print("WIN")
			battleLog.AddTextToQueue("WIN")
			pass
		BattleState.Lose:
			print("LOSE")
			battleLog.AddTextToQueue("LOSE")
			pass
	pass

func turnhandler():

	if currentTurn.type == currentTurn.Type.Creature: # Creature Turns

		
		currentTurn.creature.TurnStarted.emit()
		var usableSkills : Array[int] = currentTurn.creature.instance.GetUseableSkillsIndexes()
		for i in range(skillButtons.size()):
			skillButtons[i].hide()
			skillSelectionGraphic.hide()

		if usableSkills.size() == 0: #No Usable Skills
			print("No usable skills for "+currentTurn.creature.instance.nickName)
			battleLog.queuedDialogs.append("No usable skills for "+currentTurn.creature.instance.nickName)
			ChanceBattleState(BattleState.Idle)
			return	



		if currentTurn.creature.allied: #Player Turn Logic
			for i in range(skillButtons.size()):
				if usableSkills.has(i):
					skillButtons[i].show()
					skillButtons[i].text = currentTurn.creature.instance.skills[usableSkills[i]].name
				else:
					skillButtons[i].hide()


			SelectAndInitMove(usableSkills[0])
			pass
		else : #Opponent Turn Logic

			opponent.TurnLogic()
			pass

	pass

func SkillButtonPressed(skillIndex : int):
	if selectedSkill == skillIndex:
		UseSkill(currentTurn.creature,selectedSkill,selectedTarget)
		pass
	else :
		SelectAndInitMove(skillIndex)
	
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

func UseSkill(user : Creature,slot : int, target : Creature):

	user.UsedSkill.emit(slot,target)
	var skill : Skill = user.instance.skills[slot]
	await skill.PreformSkill(user,target)
	user.instance.skillFatigue[slot] = skill.cooldown
	turnManager.EndTurn()
	pass

func DealDamage(_attacker : Creature, target : Creature, damage : float):
	target.instance.hp -= round(damage)
	target.instance.hp = clamp(target.instance.hp,0,target.Get_Stat("maxhp"))
	target.hpbar.value = target.instance.hp
	if target.instance.hp <= 0:
		RemoveCreature(target)
		pass



enum BattleState { Init=0, Idle=1, TurnHandling=2, Win=3, Lose=4}
