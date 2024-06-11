extends Resource
class_name Status

@export var name : String = "Status Effect"
@export var atags : Array[ActivationTags.tags] = []
@export var duration : int = 1 # -1 indicates infinite duration
@export var clensable : bool = true
@export var stackable : bool = true
@export var maxStacks : int = -1 # -1 indications no limit
#@export var persistent : bool = false #Will this be saved to the creature's instance at battle end?
#@export var persistentStatus : PersistantStatus #to be implimented, will be saved to the Creature Instance

var applicant : Creature
var creature : Creature
var stacks : int = 0
 
func initForBattle(newCreature : Creature, eapplicant : Creature):
	applicant = eapplicant
	creature = newCreature
	for tag in atags:
		match tag:
			ActivationTags.tags.TURNSTART:
				creature.connect("turn_started",turn_started)
				pass
			ActivationTags.tags.TURNEND:
				creature.connect("turn_ended",turn_ended)
				pass
			ActivationTags.tags.PRETAKEDAMAGE:
				creature.connect("pre_attacked",pre_dmg)
				pass
			ActivationTags.tags.POSTTAKEDAMAGE:
				creature.connect("post_attacked",post_dmg)
				pass
			ActivationTags.tags.PREATTACK:
				creature.connect("pre_skill_used",pre_skill_used)
				pass
			ActivationTags.tags.POSTATTACK:
				creature.connect("post_skill_used",post_skill_used)
				pass
	pass

func turn_started():
	Battle.instance.battleLog.AddTextToQueue("invalid status turnstart")
	pass

func turn_ended():
	pass

func pre_dmg(packet : ActionPacket):
	pass

func post_dmg(packet : ActionPacket):
	pass

func pre_skill_used(packet : ActionPacket):
	pass
	
func post_skill_used(packet : ActionPacket):
	pass


