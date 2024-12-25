extends Node
@export var playerData : PlayerData
var init : bool = false
signal initalized
const SAVE_PATH = "user://save_data.tres"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if playerData == null:
		playerData = load_or_create()
		print("Loaded player data from file")
		pass
	else: print("Loaded premade player data")
		
	init = true
	initalized.emit()
	pass # Replace with function body.


func save() -> void:
	ResourceSaver.save(playerData,SAVE_PATH)
	pass

func clear_save() -> bool:
	if FileAccess.file_exists(SAVE_PATH):
		var res = PlayerData.new()
		ResourceSaver.save(res,SAVE_PATH)
		return true
	else :
		print("No save to clear at: \"" + SAVE_PATH + "\"")
		return false


func load_or_create() -> PlayerData:
	var res : PlayerData
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH)
	else :
		res = PlayerData.new()
	return res

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
