extends Resource
class_name ActionPacket

var generalData : Dictionary = {}

func _init(user : Creature, target : Creature, skill : Skill):
	generalData["target"] = target
	generalData["attacker"] = user
	generalData["skill"] = skill
