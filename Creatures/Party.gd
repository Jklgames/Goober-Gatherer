extends Resource
class_name Party

@export var creatures : Array[CreatureInstance] = []
@export var initalized : bool #should this party use Premade Creatures?
@export var creatureDatas : Array[CreatureData] = []

func InitializeParty():
	creatures = []
	for data in creatureDatas:
		creatures.append(CreatureInstance.new(data))
		initalized = true
		pass
	pass
