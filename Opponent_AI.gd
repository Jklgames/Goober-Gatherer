extends Resource
class_name OpponentAI

@export var difficulty : Difficulty 

func TurnLogic():
		
	await AI()
	pass

func AI():
	await Battle.instance.create_timer(0.2).timeout
	if difficulty < 0:
		
		pass
	
	pass

enum  Difficulty {Wild = 0,Starter=1 ,Easy=2 ,Trainer=3, Pro=4}
