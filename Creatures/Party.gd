extends Resource
class_name Party

var creatures : Array[CreatureInstance] = []
@export var initalized : bool #should this party use Premade Creatures?
@export var creatureDatas : Array[CreatureData] = []

func InitializeParty():
	for cData in creatureDatas:
		creatures.append(CreatureInstance.new(cData))
		initalized = true
		pass
	pass
