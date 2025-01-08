extends Panel
class_name TurnGraphic

var turn : Turn
@export var turnName : Label
@export var av : Label
var moving : bool = true
var targetHeight : float = 0


func _process(delta: float) -> void:
	if moving:
		position.y = lerpf(position.y,targetHeight,0.01)
		if position.y == targetHeight:
			moving = false
			pass
		pass
	pass
