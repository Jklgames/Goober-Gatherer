extends Resource
class_name CreatureData

@export var name : String
@export var creatureScene : PackedScene
@export_multiline var description : String
@export_group("Moves")
@export var baseMoveSet : Array[Skill] = []
@export var gooberSkill : Skill
@export_group("Stats") #Make sure they are always lowercase for "Creature.get_stat" to work
@export var maxhp = 100
@export var attack = 100
@export var defense = 100
@export var gooberGuage = 100 
@export var speed = 100
