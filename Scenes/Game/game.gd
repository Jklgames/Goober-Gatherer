extends Node3D
class_name Game

@export var battlePrefab : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var currentbattle : Battle = battlePrefab.instantiate()
	add_child(currentbattle)
	currentbattle.begin()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
