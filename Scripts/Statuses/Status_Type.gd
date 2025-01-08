extends Resource
class_name StatusType

@export var name : String = "Status Effect"
@export var startDuration : int = 1 # -1 indicates infinite duration
@export var clensable : bool = true 
@export var stackable : bool = true #If true, the last applied stack will be overwrite the previous instance, otherwise you cant reaply untill the duration is over
@export var maxStacks : int = -1 #-2 indicates the effect will be applied as seperate instances,-1 indicates no limit, 1 indicated it will simply overwrite the previous instance

#@export var persistent : bool = false #Will this be saved to the creature's instance at battle end?
#@export var persistentStatus : PersistantStatus #to be implimented, will be saved to the Creature Instance

@export var statChanges : Dictionary = {}

func turn_started(effect : StatusEffect):
	decrease_duration(effect)

func decrease_duration(effect : StatusEffect):
	if effect.duration>0:
		effect.duration -= 1
		if effect.duration == 0:
			effect.creature.statuses.erase(effect)
			Battle.instance.battleLog.add_text_to_queue(effect.creature.instance.nickname+" recovered from "+name)
			#remove status effect here
			pass
		pass
	pass


func turn_ended(effect : StatusEffect,):
	pass

func pre_dmg(packet : ActionPacket,effect : StatusEffect):
	pass

func post_dmg(packet : ActionPacket,effect : StatusEffect):
	pass

func pre_skill_used(packet : ActionPacket,effect : StatusEffect):
	pass
	
func post_skill_used(packet : ActionPacket,effect : StatusEffect):
	pass
