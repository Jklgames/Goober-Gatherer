extends Node3D
class_name Battle

static var instance : Battle

@export var opponent : OpponentAI
@export var waves : Array[Party] = []
@export_group("Refrences")
@export var turnManager : TurnManager
@export var targetSelectionGraphic : Node3D
@export var currentTurnGraphic : Node3D
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
var playerHasGottenATurn : bool = false

var currentTurn : Turn 
var selectedTarget : Creature
var currentCreature : Creature
var selectedSkillIndex : int
var possibleTargets : Array[Creature]
var selectedTargetIndex : int = 0
var usableSkillsIndexes : Array[int] = []

#region Initializations

func _ready() -> void:
	
	pass

func begin():
	for id: int in Input.get_connected_joypads():
		InputMap.get_actions()
		

	for i in range(skillButtons.size()):
		skillButtons[i].connect("pressed",Callable(self,"skill_button_pressed").bind(i))
	instance = self
	turnManager.initialize()
	turnManager.turnList.initialize()
	_initialize()
	pass


func _initialize():
	_init_allies()
	_init_enemies()
	change_battle_state(BattleState.Idle)
	pass

func _init_allies():
	var playerData : PlayerData = GameManger.playerData
	var party :Party= playerData.party
	
	if !party.initalized:
		party.InitializeParty()
		pass
	
	for i in range(min(3,party.creatures.size())):
		var cinstance : CreatureInstance = party.creatures[i]
		put_creature_in_slot(true,cinstance,i)
		pass
	pass

func _init_enemies():
	var party : Party = waves[0]
	if !party.initalized:
		party.InitializeParty()
		pass
	
	for i in range(min(3,party.creatures.size())):
		var cinstance : CreatureInstance =  party.creatures[i]
		put_creature_in_slot(false,cinstance,i)
		pass
	pass

#endregion

#region Creature Helpers
func put_creature_in_slot(isAlly:bool,cinstance:CreatureInstance,slot : int):
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

	creature.initalize_instance(cinstance)
	creature.allied = isAlly
	parentSlot.add_child(creature)
	creature.position = Vector3.ZERO
	turnManager.add_creature_turn(creature)
	#Add HP Bar
	var hpbar : Bar = creature.hpbar
	hpbar.show()
	hpbar.SetMax(creature.get_stat("maxhp"))
	hpbar.value = cinstance.hp
	hpbar.progressBar.value = hpbar.value
	pass

func remove_creature(creature : Creature):
	if creature.dead:
		return

	if creature.allied:
		allies.erase(creature)
		pass
	else:
		enemies.erase(creature)
		pass
	var turn = turnManager.get_creature_turn(creature)
	turnManager.remove_turn(turn)
	creature.dead = true
	creature.hide()
	#creature.queue_free()
	pass

#endregion

#region Update Loops
func _process(_delta):
	match battleState:
		BattleState.Idle:
			_idleing_loop()
			pass
		BattleState.TurnHandling:
			_turn_handling_loop()
			pass
		_:
			pass
	pass

func _idleing_loop():
	set_current_turn(turnManager.advance_to_next_turn());
	change_battle_state(BattleState.TurnHandling)
	pass
	
func _turn_handling_loop():
	if !currentTurn || !currentCreature || currentCreature.dead:
		turnManager.end_turn()
		return
	if (currentTurn.type == currentTurn.Type.Creature && currentCreature.allied):
		_player_turn_loop()
	pass

func _player_turn_loop():
		if Input.is_action_just_pressed("generic_interact"):
			await use_skill(currentCreature,usableSkillsIndexes[selectedSkillIndex],selectedTarget)
			#turnManager.end_turn()
			return

		if (Input.is_action_just_pressed("general_down")):
			var nextSkill = (selectedSkillIndex+1) % usableSkillsIndexes.size()
			select_and_initalize_move(nextSkill)
		elif (Input.is_action_just_pressed("general_up")):
			var nextSkill = (selectedSkillIndex-1) % usableSkillsIndexes.size()
			select_and_initalize_move(nextSkill)

		if (Input.is_action_just_pressed("general_left")):
			selectedTargetIndex -= 1
			selectedTargetIndex %= possibleTargets.size()
			set_target(possibleTargets[selectedTargetIndex])
			pass
		elif (Input.is_action_just_pressed("general_right")):
			selectedTargetIndex += 1
			selectedTargetIndex %= possibleTargets.size()
			set_target(possibleTargets[selectedTargetIndex])
			pass

#endregion

#region Battle State Logic
func change_battle_state(newState : BattleState):
	#print ("Switching from: "+BattleState.keys()[battleState]+" to "+BattleState.keys()[newState])
	battleState = newState
	match newState:
		BattleState.Idle:
			if allies.size() == 0:
				change_battle_state(BattleState.Lose)
			elif enemies.size() == 0:
				change_battle_state(BattleState.Win)
				pass
			pass
		BattleState.TurnHandling:
			_turn_handler()
			pass
		BattleState.Win:
			battleLog.add_text_to_queue("WIN")
			pass
		BattleState.Lose:
			battleLog.add_text_to_queue("LOSE")
			pass
	pass

func _turn_handler():
	if !currentTurn:
		turnManager.end_turn()
		return
		
	if currentTurn.type == currentTurn.Type.Creature: # Creature Turns
		currentTurn.creature.turn_started.emit()
		
		if !currentTurn || !currentTurn.creature || currentTurn.creature.dead: #checks if the creature died from startTurn signal
			turnManager.end_turn()
			return
		
		usableSkillsIndexes = currentTurn.creature.instance.get_useable_skill_indexes()
		
		if usableSkillsIndexes.size() == 0: #No Usable Skills
			battleLog.add_text_to_queue("No usable skills for "+currentTurn.creature.instance.nickname)
			change_battle_state(BattleState.Idle)
			return	
		if currentTurn.creature.allied: #Player Turn Logic
			playerHasGottenATurn = true
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
			select_and_initalize_move(usableSkillsIndexes[0])
			pass
		else : #Opponent Turn Logic
			if !playerHasGottenATurn:
				print("skipped opponent turn so player moves first")
				turnManager.end_turn()

			opponent.TurnLogic()
			pass
	pass

#endregion

#region Misc Helpers

func set_current_turn(turn : Turn):
	currentTurn = turn
	
	for i in range(skillButtons.size()):
		skillButtons[i].hide()
	skillSelectionGraphic.hide()
	
	if turn.type == turn.Type.Creature:
		init_creature_turn()
	else:
		currentTurnGraphic.hide()
	set_target(null)
	pass

func init_creature_turn():
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


func select_and_initalize_move(usableIndex : int):
	if  usableIndex >= usableSkillsIndexes.size():
		printerr("Invalid Slot")
		return
	
	selectedSkillIndex = usableSkillsIndexes.find(usableSkillsIndexes[usableIndex])
	
	var skillindex = usableSkillsIndexes[selectedSkillIndex]
	
	skillSelectionGraphic.show()
	skillSelectionGraphic.global_position = skillButtons[skillindex].global_position
	
	possibleTargets = currentTurn.creature.instance.skills[skillindex].possible_targets(currentTurn.creature)
	possibleTargets.sort_custom(sort_by_position_x)
	
	if !possibleTargets.has(selectedTarget):
		selectedTargetIndex = 0
		set_target(possibleTargets[0])
		pass
	else:
		set_target(selectedTarget)
		selectedTargetIndex = possibleTargets.find(selectedTarget)
		pass
	pass

func sort_by_position_x(a : Node3D, b : Node3D):
	return a.global_position.x < b.global_position.x

func set_target(target : Creature):
	if (target == null):
		targetSelectionGraphic.hide()
		return
	selectedTarget = target
	targetSelectionGraphic.position = target.global_position
	targetSelectionGraphic.show()
	pass


#endregion

#region Action Helpers

func use_skill(user : Creature,slot : int, target : Creature):
	var skill : Skill = user.instance.skills[slot]
	await skill.preform_skill(user,target)
	#turnManager.end_turn()
	pass

func process_action_packet(packet : ActionPacket):
	var pdata = packet.generalData
	var target : Creature = pdata["target"]
	var attacker : Creature = pdata["attacker"]
	
	var packetLog = packet.generalData["log"]
	battleLog.add_text_to_queue(packetLog)

	#Deal damage
	var damage = pdata["damage"] if pdata.has("damage") else 0
	var healing = pdata["healing"] if pdata.has("healing") else 0
	target.instance.hp += -damage + healing
	target.instance.hp = clamp(target.instance.hp,0,target.get_stat("maxhp"))
	target.hpbar.value = target.instance.hp
	if target.instance.hp <= 0:
		remove_creature(target)
		var logtext : String = "%s died from %s's %s" % [target.instance.nickname, attacker.instance.nickname, packet.generalData["source"]]
		battleLog.add_text_to_queue(logtext)
		pass
	else : #Creature still alive
		Battle.instance.apply_status(packet)
		pass

	pass 

func apply_status(packet):
	if !packet.generalData.has("status"):
		return
	var target : Creature = packet.generalData ["target"]
	var applicant : Creature = packet.generalData["attacker"]
	var type : StatusType = packet.generalData["status"]

	var newStatus : = StatusEffect.new(type,target,applicant) 
	#check if creature has a statuseffect with same type

	var matchingStatuses : Array[StatusEffect] = target.statuses.filter(func(x): return x.type == type)
	if matchingStatuses.size() > 0:
		if !type.stackable:
			packet["log"] += "\nbut %s already has %s" % [target.instance.nickname, type.name]
		elif type.maxStacks == -1:
			var index = target.statuses.find(matchingStatuses[0])
			newStatus.stacks = matchingStatuses[0].stacks + 1
			target.statuses[index] = newStatus
		elif type.maxStacks != -2:
			target.statuses.append(newStatus)
		pass
	else:
		target.statuses.append(newStatus)
		
 
#	for status in target.statuses:
#		if status.type == type:
	#		if !type.stackable:
	#			packet["log"] += "\nbut %s already has %s" % [target.instance.nickname, type.name]
#				return
#			if type.maxStacks == -1:
#				var index = target.statuses.find(status)
	#			status.stacks += 1
	#			target.statuses[index] = status
	#			return
#			if type.maxStacks != -2:
#				continue
#	target.statuses.append(newStatus)


#endregion

#region Ui Helpers
func skill_button_pressed(skillIndex : int):
	if !usableSkillsIndexes.has(skillIndex):
		print("Skill not usable")
		return
	
	if selectedSkillIndex == usableSkillsIndexes.find(skillIndex):
		use_skill(currentTurn.creature,skillIndex,selectedTarget)
		#turnManager.end_turn()
		pass
	else :
		select_and_initalize_move(usableSkillsIndexes.find(skillIndex))
		pass
	pass
#endregion

enum BattleState { Init=0, Idle=1, TurnHandling=2, Win=3, Lose=4}
