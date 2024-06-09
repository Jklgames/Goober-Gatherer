extends Node3D
class_name Creature

var data : CreatureData
var instance : CreatureInstance
var allied : bool
var hpbar : Bar



signal TurnStarted
signal UsedSkill(slot : int, target : Creature)

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.seek(randf_range(0,animationPlayer.current_animation_length), true)
	print(animationPlayer.current_animation + str(animationPlayer.current_animation_position))
	
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
