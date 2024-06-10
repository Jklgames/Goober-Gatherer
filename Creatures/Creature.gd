extends Node3D
class_name Creature

var data : CreatureData
var instance : CreatureInstance
var allied : bool
var hpbar : Bar

signal turn_started
signal turn_ended
signal being_attacked(skill :Skill, attacker : Creature, finalDamage:float)#PreDamageDelt
signal just_attacked(skill :Skill, attacker : Creature, finalDamage:float)#PostDamageDelt
signal using_skill(slot : int, target : Creature ,finalDamage:float)#PreDamageDelt
signal just_used_skill(slot : int, target : Creature ,finalDamage:float)#PostDamageDelt
signal die
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.seek(randf_range(0,animationPlayer.current_animation_length), true)
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
	for fatigue in instance.skillFatigue:
		fatigue = max(0,fatigue - 1)
	pass # Replace with function body.
