extends Status
class_name DOT

@export var damage : float = 10
@export var persentageHP : bool = false #If true, damage is a persentage of current HP


func _turn_started():
	var damageToDeal = damage
	if persentageHP:
		damageToDeal = creature.Get_Stat("maxHP") * damage / 100
		pass
	var packet = ActionPacket.new()
	for i in stacks:
		Battle.instance.DealDamage(packet)
		pass
	
	if duration>0:
		duration -= 1
		if duration == 0:
			#remove status effect here
			pass
		pass
	
	pass

func _turn_ended():

	pass



