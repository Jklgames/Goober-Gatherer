extends Resource
class_name Status

@export var atags : Array[ActivationTags.tags] = []
var creature : Creature

func init(newCreature : Creature):
	creature = newCreature
	for tag in atags:
		match atags:
			ActivationTags.tags.TURNSTART:
				creature.connect("turn_started",_turn_started)
				pass
			ActivationTags.tags.TURNEND:
				creature.connect("turn_ended",_turn_ended)
				pass
	pass

func _turn_started():
	pass

func _turn_ended():
	pass



