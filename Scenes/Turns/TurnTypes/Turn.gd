extends Node
class_name Turn

var type : Type
var creature : Creature # Only used by creature turns
var actionValue : float
var speed : float #Creature turns use creature speed instead
var turnGraphic : TurnGraphic

func Turn_Logic():
	pass	

enum Type {EndOfCycl=0,Creature=1}
