extends Resource
class_name CreatureData

@export var name : String
@export var creatureScene : PackedScene
@export_multiline var description
@export_group("Moves")
@export var baseMoveSet : Array[Skill] = []
@export var ultimate : Skill
@export_group("Stats")
@export var maxHP = 100
@export var attack = 100
@export var defence = 100
@export var gooberGuage = 100 
@export var speed = 100


