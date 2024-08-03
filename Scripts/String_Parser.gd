class_name StringParser
static var specialChars : Array[String] = ["<",">","/"] #Todo: Finish 
static func parse_text(rawText : String, info : StringInfo) -> String:
	var parsedText : String = ""
	var parsing : bool = false
	var exitChar = false
	for i in rawText.length():
		var char = rawText[i]
		if (specialChars.has(char) && !parsing) || exitChar:
			parsedText += char
			exitChar = false
		elif char == "<":
			parsing = true
			parsedText += _parseCode(i,rawText,info)
			pass
		elif char == ">":
			parsing = false
			pass
		elif char == "/":
			exitChar = true
			pass
		pass
	
	if parsing:
		print("Parse failed, Open <>")
		parsedText = ""
	elif exitChar:
		print("Parse failed, no special char after /")
		parsedText = ""
	
	return parsedText
	pass

static func _parseCode(currentindex : int,rawText : String, info : StringInfo) -> String:
	var returnString : String = "RetriveFailed"
	var code : String = ""
	
	for i in range(currentindex,rawText.length()):
		var char = rawText[i]
		if char == "<":
			continue
		if char == ">":
			break
		else :
			code += char
			pass
		pass
	
	if (info.info.has(code)):
		returnString = info.info[code]
	return returnString
	pass

class StringInfo:
	var info : Dictionary = {}

