extends Resource
class_name CreatureData

@export var name : String
@export var creatureScene : PackedScene
@export_multiline var description
@export_group("Moves")
@export var baseMoveSet : Array[Skill] = []
@export var ultimate : Skill
@export_group("Stats") #Make sure they are always lowercase for "Creature.Get_Stat" to work
@export var maxhp = 100
@export var attack = 100
@export var defense = 100
@export var gooberguage = 100 
@export var speed = 100


