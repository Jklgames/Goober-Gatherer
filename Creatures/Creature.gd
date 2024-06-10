extends Node3D
class_name Creature

var data : CreatureData
var instance : CreatureInstance
var allied : bool
var hpbar : Bar

signal turn_started
signal turn_ended
signal pre_attacked(packet : ActionPacket)#PreDamageDelt
signal post_attacked(packet : ActionPacket)#PostDamageDelt
signal pre_skill_used(packet : ActionPacket)#PreDamageDelt
signal post_skill_used(packet : ActionPacket)#PostDamageDelt

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.advance(randf_range(0,animationPlayer.current_animation_length))
	pass

func Get_Stat(statName : String) -> float:
	var returnStat = data.get(statName.to_lower())
	#Augmented by passives and statuses
	return returnStat

func SetInstance(newinstance : CreatureInstance):
	instance = newinstance
	data = instance.data
	#Other Initialization stuff maybe
	pass

func _on_turn_started():
	for skillFatigue in instance.skillFatigue:
		skillFatigue = max(0,skillFatigue - 1)
	pass # Replace with function body.
