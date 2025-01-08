extends RefCounted
class_name StatusEffect

var type : StatusType

var applicant : Creature
var creature : Creature
var duration : int
var stacks : int = 1

func _init(statusType : StatusType,Afflited : Creature, Applicant : Creature):
	type = statusType
	initForBattle(Afflited,Applicant)

	pass

func initForBattle(Afflited : Creature, Applicant : Creature):
	applicant = Applicant
	creature = Afflited

	creature.turn_started.connect(type.turn_started.bind(self))
	creature.turn_ended.connect(type.turn_ended.bind(self))
	creature.pre_attacked.connect(type.pre_dmg.bind(self))
	creature.post_attacked.connect(type.post_dmg.bind(self))
	creature.pre_skill_used.connect(type.pre_skill_used.bind(self))
	creature.post_skill_used.connect(type.post_skill_used.bind(self))

	#creature.connect("turn_started",type.turn_started)
	#creature.connect("turn_ended",type.turn_ended)
	#creature.connect("pre_attacked",type.pre_dmg)
	#creature.connect("post_attacked",type.post_dmg)
	#creature.connect("pre_skill_used",type.pre_skill_used)
	#creature.connect("post_skill_used",type.post_skill_used)
