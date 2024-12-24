extends Resource
class_name Party

@export var creatures : Array[CreatureInstance] = []
@export var initalized : bool #should this party use Premade Creatures?
@export var creatureDatas : Array[CreatureData] = []

func InitializeParty():
	creatures = []
	var name_count = {} # Dictionary to track name occurrences
	for data in creatureDatas:
		var new_creature = CreatureInstance.new(data)
		var nickname = new_creature.nickname
		if name_count.has(nickname):
			name_count[nickname] += 1
			nickname += str(name_count[nickname])
		else:
			name_count[nickname] = 1
			new_creature.nickname = nickname
		creatures.append(new_creature)
		pass
	initalized = true
	pass
