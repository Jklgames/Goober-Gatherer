extends Node3D
class_name Creature

var data : CreatureData
var instance : CreatureInstance
var allied : bool
var hpbar : Bar

var statuses : Array[Status] = []
var dead : bool = false

signal turn_started
signal turn_ended
signal pre_attacked(packet : ActionPacket)#PreDamageDelt
signal post_attacked(packet : ActionPacket)#PostDamageDelt
signal pre_skill_used(packet : ActionPacket)#PreDamageDelt
signal post_skill_used(packet : ActionPacket)#PostDamageDelt

@export var idleAnimationPlayer : AnimationPlayer 
@export var ActionAnimationPlayer : AnimationPlayer 

func _ready():
	idleAnimationPlayer.advance(randf_range(0,idleAnimationPlayer.current_animation_length))
	connect("turn_started",_on_turn_started)
	pass

func get_stat(statName : String) -> float:
	statName = statName.to_lower()
	var returnStat : float = instance.get_stat(statName)
	for status in statuses:
		if status.statChanges.has(statName):
			returnStat += status.statChanges[statName]
	#Augmented by passives and statuses
	return returnStat

func initalize_instance(newinstance : CreatureInstance):
	instance = newinstance
	data = instance.data
	#Other Initialization stuff maybe
	pass

func _on_turn_started():
	for i in range(instance.skillFatigue.size()):
		if instance.skillFatigue[i] > 0:
				instance.skillFatigue[i] -= 1
				pass
		pass
	pass # Replace with function body.
