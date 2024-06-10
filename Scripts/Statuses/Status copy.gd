extends Status
class_name DOT

@export var damage : float = 10
@export var persentageHP : bool = false #If true, damage is a persentage of current HP

func _turn_started():

	var damageToDeal = damage
	if persentageHP:
		damageToDeal = creature.Get_Stat("maxHP") * damage / 100

	Battle.instance.DealDamage(creature, creature, damageToDeal)
	pass

func _turn_ended():

	pass



