extends Resource
class_name ActionPacket

var generalData : Dictionary = {}

func _init(user : Creature, target : Creature, skill : Skill,SourceName : String):
	generalData["target"] = target
	generalData["attacker"] = user
	generalData["skill"] = skill
	generalData["source"] = SourceName

func getValues(valueNames : Array[String]) -> Array:
	var values : Array = []
	for valueName in valueNames:
		
		var valueParts = valueName.split(".")
		var entryName = valueParts[0] #name of generalData dictionary key
		
		if generalData.has(entryName):
			if valueParts.size() == 1:
				values.append(generalData[valueParts[0]])
				continue
			var workingValue = generalData[valueParts[0]] 
			
			for i : int in range(valueParts.size()):
				var index : int = i+1
				if index >= valueParts.size():
					values.append(workingValue)
					break
				
				workingValue = workingValue.get(valueParts[index])
				if workingValue == null:
					printerr("Value '%s' not present in '%s'" % valueParts[index],valueName)
					break
				pass
		else:
			printerr("Value '%s' not present in packet" % valueName)
	return values
	
