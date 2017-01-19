
extends PopupMenu

var handaufgabe=-1

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
		#get_node("/root/savegame").gatherReward(get_node("/root/savegame").getActiveAufgabe())
	updategui()
	pass

func updategui():
	
	if(get_node("/root/savegame").getActiveName()=="Aufgabe"):
		if(get_node("/root/savegame").getAufgabe(get_node("/root/savegame").getActiveAufgabe())[14]=="Collect-Tower"):
			handaufgabe=0
		elif(get_node("/root/savegame").getAufgabe(get_node("/root/savegame").getActiveAufgabe())[14]=="Drain-Tower"):
			handaufgabe=1
		else:
			handaufgabe=-1
	if(handaufgabe!=-1):
		get_node("RichTextLabel").show()
		get_node("VButtonArray").hide()
	else:
		get_node("RichTextLabel").hide()
		get_node("VButtonArray").show()



func _on_Abbrechen_pressed():
	hide()
	pass # replace with function body


func _on_OK_pressed():
	if(handaufgabe==-1):
		var aufgabe=-1
		if(get_node("VButtonArray").get_selected()==0):
			aufgabe=get_node("/root/savegame").getRandomTowerAufgabe(true)
		else:
			aufgabe=get_node("/root/savegame").getRandomTowerAufgabe(false)
		if aufgabe!=-1:
			var newItem=load("res://item.gd").new()
			newItem.generateAufgabe(aufgabe)
			get_node("/root/savegame").addItem(newItem)
			hide()
		else:
			get_node("RichTextLabel").set_bbcode("Du hast schon alle Aufgaben erledigt um Türme zu erstellen, ich kann dir keine mehr stellen, komm später wieder")
			get_node("RichTextLabel").show()
	else:
		if(get_node("/root/savegame").aufgabeFinished(get_node("/root/savegame").getActiveAufgabe())):
			get_node("/root/savegame").gatherReward(get_node("/root/savegame").getActiveAufgabe())
			get_node("/root/savegame").removeActiveItem()
			if(handaufgabe==0):
				var tower1=load("res://item.gd").new()
				tower1.generateItem(null,"res://textures/gatherer-tower.png","sammlerturm")
				get_node("/root/savegame").addItem(tower1)
			else:
				var tower2=load("res://item.gd").new()
				tower2.generateItem(null,"res://textures/abfluss-tower.png","abflussturm")
				get_node("/root/savegame").addItem(tower2)
			hide()
		else:
			get_node("/root/savegame").failedAufgabe(get_node("/root/savegame").getActiveAufgabe())
			get_node("RichTextLabel").set_bbcode("Scheinbar hast du die Aufgabe noch nicht richtig gelöst, überprüfe sie nochmal, und frage vielleicht Jessica")
	pass # replace with function body
