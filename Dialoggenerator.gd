
extends Control

var dependencies=[]
var loadedID

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	
	# Called every time the node is added to the scene.
	# Initialization here
	if(get_node("/root/savegame").dialogheader.empty()):
		get_node("AddDependencies").hide()
		get_node("Needed").hide()
		get_node("Dependencies").hide()
	printToScreen("Console started")
	get_node("Dependencies").set_max(get_node("/root/savegame").dialogheader.size()-1)
	get_node("Load/SpinBox").set_max(get_node("/root/savegame").dialogheader.size()-1)
	get_node("Item1/Aufgabe").set_max(get_node("/root/savegame").aufgabenheader.size()-1)
	get_node("Item2/Aufgabe").set_max(get_node("/root/savegame").aufgabenheader.size()-1)
	
	get_node("Character").add_item("Anja",0)
	get_node("Character").add_item("Maurice",1)
	get_node("Character").add_item("Marja",2)
	get_node("Character").add_item("Mina",3)
	get_node("Character").add_item("Fritz",4)
	get_node("Character").add_item("Angie",5)
	get_node("Character").add_item("Maik",6)
	get_node("Character").add_item("Lucia",7)
	get_node("Character").add_item("Torben",8)
	get_node("Character").add_item("Jessica",9)
	get_node("Character").add_item("Jay",10)
	if(get_node("/root/global").dialogToLoad!=-1):
		loaddialog(get_node("/root/global").dialogToLoad)
	pass


func printToScreen(stringToPrint):
	get_node("ConsoleOut").set_bbcode(str(stringToPrint,"\n",get_node("ConsoleOut").get_bbcode()))


func _on_Type_value_changed( value ):
	if value==0:
		printToScreen("Type: Quest bekommen")
		get_node("Backtalk2").set_hidden(true)
		get_node("Item1").set_hidden(false)
		get_node("Item2").set_hidden(true)
		get_node("Item1/Button").set_disabled(true)
		get_node("Item1/Icon").set_editable(false)
		get_node("Item1/Icon").set_text("blueprint.png")
		get_node("Item1/Name").set_editable(false)
		get_node("Item1/Name").set_text("Aufgabe")
		get_node("AnswerA").set_text("Ok, mach ich")
		get_node("AnswerD").set_text("Gerade nicht, bis bald")
		get_node("AnswerW").set_text("Was soll ich für dich Tun?")
	elif value==1:
		printToScreen("Type: Quatschen")
		get_node("Backtalk2").set_hidden(false)
		get_node("Item1").set_hidden(true)
		get_node("Item2").set_hidden(true)
		get_node("AnswerA").set_text("Aha ^_^")
		get_node("AnswerW").set_text("Wie meinst du das genau?")
		get_node("AnswerD").set_text("Ich muss los, bis bald")
	elif value==2:
		printToScreen("Type: Quest abgeben")
		get_node("Backtalk2").set_hidden(false)
		get_node("Item1").set_hidden(true)
		get_node("Item2").set_hidden(false)
		get_node("Item2/Aufgabe").set_editable(false)
		get_node("Item2/Button").set_disabled(true)
		get_node("Item2/Icon").set_editable(false)
		get_node("Item2/Icon").set_text("blueprint.png")
		get_node("Item2/Name").set_editable(false)
		get_node("Item2/Name").set_text("Aufgabe")
		get_node("AnswerA").set_text("Hier, ich hab es fertig")
		get_node("AnswerD").set_text("Bin noch nicht fertig, bis bald")
		get_node("AnswerW").set_text("Kannst du mir helfen?")
		get_node("Backtalk1").set_text("Vielleicht kann dir Jessica helfen? die weiss bei solchen Fragen oft Bescheid")
		get_node("Backtalk2").set_text("Danke für die Arbeit, aber du hast da noch Fehler gemacht, bitte korrigiere die noch schnell")
		getQuestBack()
	elif value==3:
		printToScreen("Type: Tauschhandel")
		get_node("Backtalk2").set_hidden(false)
		get_node("Item1").set_hidden(false)
		get_node("Item2").set_hidden(false)
		get_node("Item1/Button").set_disabled(false)
		get_node("Item1/Icon").set_editable(true)
		get_node("Item1/Name").set_editable(true)
		get_node("Item2/Aufgabe").set_editable(true)
		get_node("Item2/Button").set_disabled(false)
		get_node("Item2/Icon").set_editable(true)
		get_node("Item2/Name").set_editable(true)
		get_node("Item2/Name").get_text()
		get_node("AnswerA").set_text("Ok, tauschen wir")
		get_node("AnswerW").set_text("Was willst du mit mir tauschen?")
		get_node("AnswerD").set_text("Nein, gerade nicht")
		get_node("Backtalk1").set_text(str("Also, du hilfst mir ein Objekt namens '",get_node("Item2/Name").get_text(),"' zu finden, und ich geb dir ein Objekt namens '",get_node("Item1/Name").get_text(),"', Ok?"))
		get_node("Backtalk2").set_text("Du hast doch noch garnicht, worum ich dich gebeten hab, bitte komm wieder wenn du es hast")
	#0-> Quest bekommen
	#1-> Reden
	#2-> Quest abgeben
	#3-> Tauschhandel
	pass # replace with function body

func getQuestBack():
	if(!dependencies.empty()):
		var back=get_node("/root/savegame").dialogbody[dependencies[0]]
		print(back)
		get_node("Item2/Aufgabe").set_value(back[1][6][0])
	pass

func _on_Dependencies_value_changed( value ):
	var header=get_node("/root/savegame").getDialogheader(value)
	var footer=get_node("/root/savegame").getDialogfooter(value)
	var type="'Quest bekommen'"
	if footer[8]==1:
		type="'Quatschen'"
	if footer[8]==2:
		type="'Quest abgeben'"
	if footer[8]==3:
		type="'Tauschhandel'"
	printToScreen(str("Dialog ",value," ist ein ",type," Typ mit ",header[0]," mit dem Text:\n",footer[0]))
	pass # replace with function body


func _on_Button_pressed():
	if(File.new().file_exists(str("textures/Icons/",get_node("Item1/Icon").get_text()))):
		printToScreen("Die Datei Existiert")
	else:
		printToScreen("Die Datei Existiert nicht")
	pass # replace with function body


func _on_Button2_pressed():
	if(File.new().file_exists(str("textures/Icons/",get_node("Item2/Icon").get_text()))):
		printToScreen("Die Datei Existiert")
	else:
		printToScreen("Die Datei Existiert nicht")
	pass # replace with function body


func _on_Save_pressed():
	var number=0
	var stillexists=true
	while stillexists:
		if(File.new().file_exists(str("Dialoge/Dialog_",number,".dialog"))):
			number+=1
		else:
			stillexists=false
	if(!get_node("Save/CheckBox").is_pressed() or loadedID==-1):
		get_node("/root/import_export").exportDialog(str("Dialoge/Dialog_",number,".dialog"),[[get_node("Character").get_text(),dependencies,get_node("Dependenciespoints").get_value(),get_node("Action").get_value()],[get_node("Dialogtext").get_text(),get_node("AnswerW").get_text(),get_node("AnswerA").get_text(),get_node("AnswerD").get_text(),get_node("Backtalk2").get_text(),get_node("Backtalk1").get_text(),[get_node("Item1/Aufgabe").get_value(),get_node("Item1/Icon").get_text(),get_node("Item1/Name").get_text()],[get_node("Item2/Aufgabe").get_value(),get_node("Item2/Icon").get_text(),get_node("Item2/Name").get_text()],get_node("Type").get_value()]])
		printToScreen("Dialog exportiert")
	else:
		get_node("/root/import_export").exportDialog(str("Dialoge/Dialog_",loadedID,".dialog"),[[get_node("Character").get_text(),dependencies,get_node("Dependenciespoints").get_value(),get_node("Action").get_value()],[get_node("Dialogtext").get_text(),get_node("AnswerW").get_text(),get_node("AnswerA").get_text(),get_node("AnswerD").get_text(),get_node("Backtalk2").get_text(),get_node("Backtalk1").get_text(),[get_node("Item1/Aufgabe").get_value(),get_node("Item1/Icon").get_text(),get_node("Item1/Name").get_text()],[get_node("Item2/Aufgabe").get_value(),get_node("Item2/Icon").get_text(),get_node("Item2/Name").get_text()],get_node("Type").get_value()]])
		printToScreen("Dialog überschrieben")
	
	pass # replace with function body

func updateNeeded():
	get_node("Needed").set_text(str("Benötigt: ",dependencies))
	

func _on_AddDependencies_pressed():
	if(dependencies.find(get_node("Dependencies").get_value())==-1):
		dependencies.push_back(get_node("Dependencies").get_value())
	if(get_node("Type").get_value()==2):
		getQuestBack()
	updateNeeded()
	pass # replace with function body


func _on_loaddialog_value_changed( value ):
	var header=get_node("/root/savegame").getDialogheader(value)
	var footer=get_node("/root/savegame").getDialogfooter(value)
	var type="'Quest bekommen'"
	if footer[8]==1:
		type="'Quatschen'"
	if footer[8]==2:
		type="'Quest abgeben'"
	if footer[8]==3:
		type="'Tauschhandel'"
	printToScreen(str("Dialog ",value," ist ein ",type," Typ mit ",header[0]," mit dem Text:\n",footer[0]))
	pass # replace with function body


func _on_Load_pressed():
	loaddialog(get_node("Load/SpinBox").get_value())
	pass # replace with function body

func loaddialog(value):
	var header=get_node("/root/savegame").getDialogheader(value)
	var footer=get_node("/root/savegame").getDialogfooter(value)
	var char=0
	while(get_node("Character").get_text()!=header[0] and !char==get_node("Character").get_item_count()-1):
		char += 1
		get_node("Character").select(char)
	dependencies=header[1]
	updateNeeded()
	get_node("Dependenciespoints").set_value(header[2])
	get_node("Action").set_value(header[3])
	get_node("Dialogtext").set_text(footer[0])
	get_node("AnswerW").set_text(footer[1])
	get_node("AnswerA").set_text(footer[2])
	get_node("AnswerD").set_text(footer[3])
	get_node("Backtalk2").set_text(footer[4])
	get_node("Backtalk1").set_text(footer[5])
	get_node("Item1/Aufgabe").set_value(footer[6][0])
	get_node("Item1/Icon").set_text(footer[6][1])
	get_node("Item1/Name").set_text(footer[6][2])
	get_node("Item2/Aufgabe").set_value(footer[7][0])
	get_node("Item2/Icon").set_text(footer[7][1])
	get_node("Item2/Name").set_text(footer[7][2])
	get_node("Type").set_value(footer[8])
	loadedID=value
	

func _on_abbrechen_pressed():
	get_node("/root/global").setScene("mainmenu.scn")
	pass # replace with function body
