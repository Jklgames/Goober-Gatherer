extends Node3D
class_name Battle

static var instance : Battle

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
var currentCreature : Creature
var selectedSkillIndex : int
var possibleTargets : Array[Creature]
var selectedTargetIndex : int = 0
var usableSkillsIndexes : Array[int] = []

#region Initializations
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
	_init_allies()
	_init_enemies()
	ChangeBattleState(BattleState.Idle)
	pass

func _init_allies():
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

func _init_enemies():
	var party : Party = waves[0]
	if !party.initalized:
		party.InitializeParty()
		pass
	
	for i in range(min(3,party.creatures.size())):
		var cinstance : CreatureInstance =  party.creatures[i]
		SlotInCreature(false,cinstance,i)
		pass
	pass

#endregion

#region Creature Helpers
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
	if creature.dead:
		return

	if creature.allied:
		allies.remove_at(allies.find(creature))
		pass
	else:
		enemies.remove_at(enemies.find(creature))
		pass
	var turn = turnManager.GetCreatureTurn(creature)
	turnManager.RemoveTurn(turn)
	creature.dead = true
	creature.hide()
	#creature.queue_free()
	pass

#endregion

#region Update Loops
func _process(_delta):
	
	match battleState:
		BattleState.Idle:
			_idlein_loop()
			pass
		BattleState.TurnHandling:
			_turn_handling_loop()
			pass
		_:
			pass
	pass

func _idlein_loop():
	SetCurrentTurn(turnManager.Advance_To_Next_Turn());
	ChangeBattleState(BattleState.TurnHandling)
	pass
	
func _turn_handling_loop():
	if !currentTurn || !currentCreature || currentCreature.dead:
		turnManager.EndTurn()
		return
	if (currentTurn.type == currentTurn.Type.Creature && currentCreature.allied):
		_player_turn_loop()
	pass

func _player_turn_loop():
		if Input.is_action_just_pressed("generic_interact"):
			await UseSkill(currentCreature,usableSkillsIndexes[selectedSkillIndex],selectedTarget)
			return

		if (Input.is_action_just_pressed("general_down")):
			var nextSkill = (selectedSkillIndex+1) % usableSkillsIndexes.size()
			SelectAndInitMove(nextSkill)
		elif (Input.is_action_just_pressed("general_up")):
			var nextSkill = (selectedSkillIndex-1) % usableSkillsIndexes.size()
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

#endregion

#region Battle State Logic
func ChangeBattleState(newState : BattleState):
	#print ("Switching from: "+BattleState.keys()[battleState]+" to "+BattleState.keys()[newState])
	battleState = newState
	match newState:
		BattleState.Idle:
			if allies.size() == 0:
				ChangeBattleState(BattleState.Lose)
			elif enemies.size() == 0:
				ChangeBattleState(BattleState.Win)
				pass
			pass
		BattleState.TurnHandling:
			_turn_handler()
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

func _turn_handler():
	if !currentTurn:
		turnManager.EndTurn()
		return
		
	if currentTurn.type == currentTurn.Type.Creature: # Creature Turns
		currentTurn.creature.turn_started.emit()
		
		if !currentTurn || !currentTurn.creature || currentTurn.creature.dead: #checks if the creature died from startTurn signal
			turnManager.EndTurn()
			return
		
		usableSkillsIndexes = currentTurn.creature.instance.GetUseableSkillsIndexes()
		
		if usableSkillsIndexes.size() == 0: #No Usable Skills
			print("No usable skills for "+currentTurn.creature.instance.nickName)
			battleLog.queuedDialogs.append("No usable skills for "+currentTurn.creature.instance.nickName)
			ChangeBattleState(BattleState.Idle)
			return	
		if currentTurn.creature.allied: #Player Turn Logic
			for i in range(4):
				
				if usableSkillsIndexes.has(i):
					skillButtons[i].show()
					skillButtons[i].disabled = false
					skillButtons[i].text = currentTurn.creature.instance.skills[i].name
					pass
				elif currentTurn.creature.instance.skills.size() > i:
					skillButtons[i].show()
					skillButtons[i].disabled = true
					skillButtons[i].text = currentTurn.creature.instance.skills[i].name
					pass
				else:
					skillButtons[i].hide()
					pass
			SelectAndInitMove(usableSkillsIndexes[0])
			pass
		else : #Opponent Turn Logic
			opponent.TurnLogic()
			pass
	pass

#endregion

#region Misc Helpers

func SetCurrentTurn(turn : Turn):
	currentTurn = turn
	
	for i in range(skillButtons.size()):
		skillButtons[i].hide()
	skillSelectionGraphic.hide()
	
	if turn.type == turn.Type.Creature:
		InitCreatureTurn()
	else:
		currentTurnGraphic.hide()
	SetTarget(null)
	pass

func InitCreatureTurn():
	currentCreature = currentTurn.creature
	currentTurnGraphic.show()
	currentTurnGraphic.position = currentCreature.global_position
	if currentCreature.allied:
		currentTurnGraphic.scale.x *=-1
		pass
	else:
		currentTurnGraphic.scale.x = abs(currentTurnGraphic.scale.x)
		pass
	pass


func SelectAndInitMove(usableIndex : int):
	if  usableIndex >= usableSkillsIndexes.size():
		print("Invalid Slot")
		return
	
	selectedSkillIndex = usableSkillsIndexes.find(usableSkillsIndexes[usableIndex])
	
	var skillindex = usableSkillsIndexes[selectedSkillIndex]
	
	skillSelectionGraphic.show()
	skillSelectionGraphic.global_position = skillButtons[skillindex].global_position
	
	possibleTargets = currentTurn.creature.instance.skills[skillindex].PossibleTargets(currentTurn.creature)
	possibleTargets.sort_custom(sortbyXPos)
	
	if !possibleTargets.has(selectedTarget):
		selectedTargetIndex = 0
		SetTarget(possibleTargets[0])
		pass
	else:
		SetTarget(selectedTarget)
		selectedTargetIndex = possibleTargets.find(selectedTarget)
		pass
	pass

func sortbyXPos(a : Node3D, b : Node3D):
	return a.global_position.x < b.global_position.x

func SetTarget(target : Creature):
	if (target == null):
		targetSelectionGraphic.hide()
		return
	selectedTarget = target
	targetSelectionGraphic.position = target.global_position
	targetSelectionGraphic.show()
	pass


#endregion

#region Action Helpers

func UseSkill(user : Creature,slot : int, target : Creature):
	var skill : Skill = user.instance.skills[slot]
	await skill.PreformSkill(user,target)
	turnManager.EndTurn()
	pass

func DealDamage(packet : ActionPacket):
	var damage : float = packet.generalData["damage"]
	if damage == 0:
		return
	
	var target : Creature = packet.generalData ["target"]
	var attacker : Creature = packet.generalData["attacker"]
	
	target.instance.hp -= round(damage)
	target.instance.hp = clamp(target.instance.hp,0,target.Get_Stat("maxhp"))
	target.hpbar.value = target.instance.hp
	if target.instance.hp <= 0:
		RemoveCreature(target)
		pass

func ApplyStatus(packet):
	if !packet.generalData.has("status"):
		return
	var status : Status = packet.generalData["status"].duplicate()
	if !status:
		return
	var target : Creature = packet.generalData ["target"]
	var applicant : Creature = packet.generalData["attacker"]
	 
	target.statuses.append(status)
	status.initForBattle(target,applicant)
	pass

#endregion

#region Ui Helpers
func SkillButtonPressed(skillIndex : int):
	if !usableSkillsIndexes.has(skillIndex):
		print("Skill not usable")
		return
	
	var skill :Skill = currentCreature.instance.skills[skillIndex]
	if selectedSkillIndex == usableSkillsIndexes.find(skillIndex):
		UseSkill(currentTurn.creature,skillIndex,selectedTarget)
		pass
	else :
		SelectAndInitMove(usableSkillsIndexes.find(skillIndex))
		pass
	pass

#endregion

enum BattleState { Init=0, Idle=1, TurnHandling=2, Win=3, Lose=4}
