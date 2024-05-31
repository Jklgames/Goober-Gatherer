extends Node
class_name Turn
@export var actionValue : float
@export var data : Dictionary = {}
var turnGraphic : TurnGraphic

func Turn_Logic():
	pass

func _sort(a, b):
	return a.actionValue < b.actionValue
