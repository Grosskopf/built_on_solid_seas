
extends Node

var aufgabenheader=[]
var aufgabenbody=[]
var Items=[]
var ItemsLoading=[]
var Points=0
var Resources=0
var doneDialogs=[]
var dialogheader=[]
var dialogbody=[]
var nextdialogs=[null,null,null,null,null,null,null,null,null,null,null]
var changedWorldcells=[]
var changedWorldcellto=[]
var TDPlane=[]
#aufgaben bestehen aus nummer, dateiname, status, reward und versuche
#status ist ein array der aufgabenteile die schon richtig gelöst sind
var actionsdone=[false,false,false,false,false]
#actions sind 0. Intro fertig, 1. Wand gebaut, 2. erster Test
var leveltype=[0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5]
var showquestsign=[false,false,false,false,false,false,false,false,false,false,false]

func _ready():
	print("Initialisation of savegame")
	# Initialization here
	#aufgaben.push_back([0,"Aufgaben/Aufgabe_0_0.aufgabe",[false]])
	loadAufgaben()
	loadDialogs()
	calculateNextDialogs()
	print("Initialisation of savegame ended")
	pass

func changedTDPlane(location,type, level):#Wallvert, Wallhorizont, collector, drain
	for TDplaneElem in TDPlane:
		if TDplaneElem[0]==location and TDplaneElem[1].x==type:
			TDPlane.remove(TDPlane.find(TDplaneElem))
	
	TDPlane.push_back([location,Vector2(type,level)])

func removeActiveItem():
	var selected=get_node("/root/global").getItemselected()
	if(Items.size()>selected):
		Items.remove(selected)

func changedworldcell(location,type):
	var index=changedWorldcells.find(location)
	if(index==-1):
		changedWorldcells.push_back(location)
		changedWorldcellto.push_back(type)
	else:
		changedWorldcells[index]=location
		changedWorldcellto[index]=type

func setDialogfinisched(number):
	if(doneDialogs.find(number)==-1):
		doneDialogs.push_back(number)
	calculateNextDialogs()

func getNextDialogFor(name):
	var actualperson=0
	if name=="Anja":
		actualperson=0
	elif name=="Maurice":
		actualperson=1
	elif name=="Marja":
		actualperson=2
	elif name=="Mina":
		actualperson=3
	elif name=="Fritz":
		actualperson=4
	elif name=="Angie":
		actualperson=5
	elif name=="Maik":
		actualperson=6
	elif name=="Lucia":
		actualperson=7
	elif name=="Torben":
		actualperson=8
	elif name=="Jessica":
		actualperson=9
	elif name=="Jay":
		actualperson=10
	return dialogbody[nextdialogs[actualperson]]

func getActiveJessicamessage():
	if(getActiveName()!="Aufgabe"):
		return "Lass mal sehen, mit dem was du da grad in der Hand her Hand hältst kann ich irgendwie nichts anfangen"
	else:
		var type=calculatetype(aufgabenbody[getActiveAufgabe()][1][10],aufgabenbody[getActiveAufgabe()][1][12])
		if type==0:
			return "Da musst du wohl nur ein paar Quadratzahlen berechnen oder Wurzeln ziehen, schau mal ab Seite 81 ins Mathebuch"
		elif type==1:
			return "Dafür brauchst du nur den Satz des Pythagoras, a²+b²=c², c ist die Lange seite, und a und b sind die Kurzen, stell die Formel um wie du sie brauchst oder schau mal ab seite 94 ins Buch"
		elif type==2:
			return "Dafür brauchst du wohl Höhen- oder Kathetensatz, hier ist die Hypothenuse (die Lange Seite) aufgeteilt in zwei kurze, je nach dem welche hälfte du mit der länge von der ganzen multiplizierst, hast du die unterschiedlichen Quadrate an den Katheten beim Kathetensatz, beim Höhensatz nimmst du die beiden teile miteinander mal und bekommst das quadrat mit der Länge die die Höhe hat, schau mal auf Seite 100"
		elif type==3:
			return "Du musst hier wohl nur Umfänge berechnen das ging mit PI mal Durchmesser, der Durchmesser (die ganze Breite von dem Kreis) ist doppelt so lang wie der Radius(die halbe Breite), PI ist eine ganz normale Zahl, ungefähr 3,1415..."
		elif type==4:
			return "Du musst hier wohl den Flächeninhalt von Kreisen berechnen das ging mit PI mal Radius mal Radius ( oder PI mal r²), der Radius ist die Länge vom mittelpunkt nach aussen, PI ist eine ganz normale Zahl, ungefähr 3,1415..."
		elif type==5:
			return "Oh das ist eine Kompliziertere aufgabe, schau mal welche Formen du erkennst, vielleicht hilft es dir weiter dass du immer bei Kreisabschnitten mit dem Winkel multiplizieren darfst, wenn du dann durch 360° teilst, dann rechne Große flächen aus und zieh die Löcher davon ab, oder Flächen die nebeneinander liegen berechnest du einzeln, du findest schon einen Weg, aber pass auf, dass du nicht verwechselst was wovon abgezogen werden muss"
		elif type==6:
			return "Du musst hier wohl nur Oberflächenteile von einem Zylinder ausrechnen, schau mal nach, Ein zylinder das sind ja nur 2 Kreise oben und unten, und drum herrum ist der Mantel, ein ganz normales Rechteck mit den kanten die so lang sind wie die Höhe und der Umfang von dem kreis, wenn du es auseinander nimmst. Die Teile kannst du einfach zusammenaddieren schau mal auf seite 136"
		elif type==7:
			return "Du musst hier wohl nur das Volumen von einem Zylinder berechnen, ich merke mir das immer mit der Pizza formel, weil bei einem Radius von z und einer höhe von a ist die Formel Pi mal z mal z mal a also Pizza, wie bei allen anderen Prismen auch Grundfläche(Kreis) mal Höhe, schau mal auf seite 140"
		elif type==8:
			return "Du musst hier wohl Volumen von Teilen berechnen wo Teile draus ausgeschnitten sind, nimm einfach die Teile die mit Löchern da sind und zieh die Löcher ab"
		elif type==9:
			return "Oh das ist wohl eine Kegeloberfläche, ein kegel besteht immer aus Mantel und Kreis, den Kreis kennst du ja, und der Mantel ist ja auch nur ein Kreisabschnitt, rechne einfach, wie groß der winkel wäre wenn du den Kreisumfang von dem Kreis als Bogen für den Mantel siehst, und den mantel so aufschneidest, mit dem Winkel und dem Radius (Mantellänge) kannst du dann den Mantel berechnen, und alles zusammenrechnen, schau mal auf seite 163"
		elif type==10:
			return "Ah das ist ein Kegelvolumen, ein kegelvolumen ist fast wie ein Zylindervolumen, es fehlen nur 2/3, rechne also den Zylinder aus, der um den Kegel passt und teil das Ergebniss durch 3, schau mal auf Seite 167"
		elif type==11:
			return "Ah eine Pyramidenoberfläche, hier musst du einfach die Dreiecke von dem Mantel zusammenrechnen und dann die Fläche unten in Dreiecke oder andere Flächen aufteilen, bei denen du weisst wie man die Größe berechnet, dann alles zusammenrechnen und schon hast du die Oberfläche"
		elif type==12:
			return "Ach ein Pyramidenvolumen, genau wie beim Kegel rechnest du das passende Prisma aus (Grundfläche mal Höhe) und teilst das Ergebniss durch 3, weil genau so viel volumen Fehlt"
		elif type==13:
			return "Ui, eine Kugel, kugeln sind Kompliziert, da nützt es nichts anderes als die Formeln zu merken, Oberfläche ist 4 mal Pi mal Radius mal Radius, für das Volumen rechnest du das nochmal mal Radius und teilst das ganze durch 3, wie auf seite 172 erklärt"

func calculateNextDialogs():
	var actualperson=0
	var nextdialogtmp=[[],[],[],[],[],[],[],[],[],[],[]]
	for dialognr in range(dialogheader.size()):
		var dialogpossible=true
		if dialogheader[dialognr][1][0]=="Anja":
			actualperson=0
		elif dialogheader[dialognr][1][0]=="Maurice":
			actualperson=1
		elif dialogheader[dialognr][1][0]=="Marja":
			actualperson=2
		elif dialogheader[dialognr][1][0]=="Mina":
			actualperson=3
		elif dialogheader[dialognr][1][0]=="Fritz":
			actualperson=4
		elif dialogheader[dialognr][1][0]=="Angie":
			actualperson=5
		elif dialogheader[dialognr][1][0]=="Maik":
			actualperson=6
		elif dialogheader[dialognr][1][0]=="Lucia":
			actualperson=7
		elif dialogheader[dialognr][1][0]=="Torben":
			actualperson=8
		elif dialogheader[dialognr][1][0]=="Jessica":
			actualperson=9
		elif dialogheader[dialognr][1][0]=="Jay":
			actualperson=10
		for Dependencie in dialogheader[dialognr][1][1]:
			if doneDialogs.find(Dependencie)==-1:
				dialogpossible=false
		if(dialogheader[dialognr][1][2]>0 and dialogheader[dialognr][1][2]<Points):
			dialogpossible=true
		if(dialogheader[dialognr][1][3]!=0 and !actionsdone[dialogheader[dialognr][1][3]]):
			dialogpossible=false
		if dialogbody[dialognr][1][8]!=1 and doneDialogs.find(dialognr)!=-1:
			dialogpossible=false
		if dialogpossible:
			nextdialogtmp[actualperson].push_back(dialognr)
	for person in nextdialogtmp:
		showquestsign[nextdialogtmp.find(person)]=false
		var tmpquatschen=[]
		var tmpaufgaben=[]
		var tmpresult=[]
		var tmptrade=[]
		for dialog in person:
			if(dialogbody[dialog][1][8]==0):
				tmpaufgaben.push_back(dialog)
			elif(dialogbody[dialog][1][8]==1):
				tmpquatschen.push_back(dialog)
			elif(dialogbody[dialog][1][8]==2):
				tmpresult.push_back(dialog)
			elif(dialogbody[dialog][1][8]==3):
				tmptrade.push_back(dialog)
		if(!tmpresult.empty()):
			nextdialogs[nextdialogtmp.find(person)]=tmpresult[tmpresult.size()-1]
		elif(!tmptrade.empty()):
			nextdialogs[nextdialogtmp.find(person)]=tmptrade[tmptrade.size()-1]
		elif(!tmpaufgaben.empty()):
			var distance=[]
			var actual=[0,100000]
			for i in range(tmpaufgaben.size()):
				var aufgabe=dialogbody[tmpaufgaben[i]][1][6][0]
				distance.push_back(abs(aufgabenbody[aufgabe][1][11]-leveltype[calculatetype(aufgabenbody[aufgabe][1][10],aufgabenbody[aufgabe][1][12])]))
				if(distance[distance.size()-1]<actual[1]):
					actual[0]=distance.size()-1
					actual[1]=distance[distance.size()-1]
			nextdialogs[nextdialogtmp.find(person)]=tmpaufgaben[actual[0]]
			showquestsign[nextdialogtmp.find(person)]=true
		elif(!tmpquatschen.empty()):
			nextdialogs[nextdialogtmp.find(person)]=tmpquatschen[tmpquatschen.size()-1]
	if(get_tree().get_root().has_node("Welt/Characters")):
		get_tree().get_root().get_node("Welt/Characters/Anja").setshowquestsign(showquestsign[0])
		get_tree().get_root().get_node("Welt/Characters/Maurice").setshowquestsign(showquestsign[1])
		get_tree().get_root().get_node("Welt/Characters/Marja").setshowquestsign(showquestsign[2])
		get_tree().get_root().get_node("Welt/Characters/Mina").setshowquestsign(showquestsign[3])
		get_tree().get_root().get_node("Welt/Characters/Fritz").setshowquestsign(showquestsign[4])
		get_tree().get_root().get_node("Welt/Characters/Angie").setshowquestsign(showquestsign[5])
		get_tree().get_root().get_node("Welt/Characters/Maik").setshowquestsign(showquestsign[6])
		get_tree().get_root().get_node("Welt/Characters/Lucia").setshowquestsign(showquestsign[7])
		get_tree().get_root().get_node("Welt/Characters/Torben").setshowquestsign(showquestsign[8])
		get_tree().get_root().get_node("Welt/Characters/Jessica").setshowquestsign(showquestsign[9])
		get_tree().get_root().get_node("Welt/Characters/Jay").setshowquestsign(showquestsign[10])

func calculatetype(chapter,input):
	if(chapter==0):
		if(input[2]):
			return 2
		elif(input[1]):
			return 1
		else:
			return 0
	elif(chapter==1):
		if(input[4] or input[3]):
			return 5
		elif(input[1]):
			return 4
		else:
			return 3
	elif(chapter==2):
		if(input[2]):
			return 8
		if(input[1]):
			return 7
		else:
			return 6
	else:
		if(input[4]):
			return 13
		elif(input[3] and input[1]):
			return 12
		elif(input[3] and input[0]):
			return 11
		elif(input[2] and input[1]):
			return 10
		else:
			return 9

func aufgabeFinished(nummer):
	for aufgabe in aufgabenheader:
		if aufgabe[0]==nummer:
			var finished=true
			for solved in aufgabe[2]:
				if !solved:
					finished=false
			return finished

func aufgabeGot(nummer):
	for item in Items:
		if item.name=="Aufgabe" and item.aufgabe==nummer:
			return true
	return false

func chapterfree(nummer):
	for aufgabe in aufgabenbody:
		if aufgabe[0]==nummer:
			if aufgabe[1][10]==0:
				return true
			elif aufgabe[1][10]==1 and actionsdone[3]:
				return true
			else:
				return false

func getRandomTowerAufgabe(iscollectortype):
	var tmpaufgaben=[]
	for aufgabe in aufgabenbody:
		if aufgabe[1][14]=="Collect-Tower" and iscollectortype and !aufgabeFinished(aufgabe[0]) and !aufgabeGot(aufgabe[0]) and chapterfree(aufgabe[0]):
			tmpaufgaben.push_back(aufgabe[0])
		elif aufgabe[1][14]=="Drain-Tower" and !iscollectortype and !aufgabeFinished(aufgabe[0]) and !aufgabeGot(aufgabe[0]) and chapterfree(aufgabe[0]):
			tmpaufgaben.push_back(aufgabe[0])
	var distance=[]
	var actual=[0,100000]
	for i in range(tmpaufgaben.size()):
		var aufgabe=dialogbody[tmpaufgaben[i]][1][6][0]
		distance.push_back(abs(aufgabenbody[aufgabe][1][11]-leveltype[calculatetype(aufgabenbody[aufgabe][1][10],aufgabenbody[aufgabe][1][12])]))
		if(distance[distance.size()-1]<actual[1]):
			actual[0]=distance.size()-1
			actual[1]=distance[distance.size()-1]
	var aufgabe=-1
	if (distance.empty()):
		var possible=[]
		for i in range(distance.size()):
			var j=distance.size()-1-i
			if distance[j]==actual[1]:
				possible.push_back(j)
		aufgabe=tmpaufgaben[possible[randi()%possible.size()]]
	return aufgabe

func loadAufgaben():
	var tmpbool=true
	var nummer=0
	var i=0
	var j=0
	while tmpbool:
#		if(j>0):
#			print("having j=",j," j=",i)
		if(File.new().file_exists(str("Aufgaben/Kapitel_",j,"_Aufgabe_",i,".aufgabe"))):
			var tmparray=[]
			var info=get_node("/root/import_export").importBlueprint(str("Aufgaben/Kapitel_",j,"_Aufgabe_",i,".aufgabe"))
			for i in range(info[5].size()):
				tmparray.push_back(false)
			aufgabenheader.push_back([nummer,str("Aufgaben/Kapitel_",j,"_Aufgabe_",i,".aufgabe"),tmparray,info[15],0])
			#if(info[14]!="Collect-Tower" and info[14]!="Drain-Tower"):
			#	print(nummer,": Kapitel ",j," Aufgabe ",i," Von ",info[14]," Text ",info[13])
			info.resize(15)
			aufgabenbody.push_back([nummer,info])
			nummer+=1
			i+=1
			
			#print("before!!!")
			#if(j>0):
			#	print("IT WORKS!!!")
		else:
			if j<4:
				j+=1
				i=0
			else:
				tmpbool=false
	print(nummer," Aufgaben geladen")

func getAufgabe(nummer):
	for aufgabe in aufgabenbody:
		if nummer==aufgabe[0]:
			return aufgabe[1]
	pass
	

func getTaskNr(var chapter,var number):
	for aufgabe in aufgabenheader:
		if aufgabe[1]==str("Aufgaben/Kapitel_",chapter,"_Aufgabe_",number,".aufgabe"):
			return aufgabe[0]

func loadDialogs():
	print("loading dialogs")
	var tmpbool=true
	var i=0
	while tmpbool:
		if(File.new().file_exists(str("Dialoge/Dialog_",i,".dialog"))):
			var info=get_node("/root/import_export").importDialog(str("Dialoge/Dialog_",i,".dialog"))
			dialogheader.push_back([i,info[0]])
			dialogbody.push_back([i,info[1]])
			i+=1
		else:
			print("loaded ",i," Dialogs")
			tmpbool=false
			#info besteht aus den für den Dialog wichtigen elementen, und den informationen wann und wo dieser Dialog auftritt (bedingungen und person)


func getItem(i):
	#print(Items)
	return Items[i]

func getActiveName():
	var selected=get_node("/root/global").getItemselected()
#	var Itemssize=
	if(Items.size()>selected):
		return Items[selected].name
	else:
		return ""

func addItem(item):
	Items.push_back(item)
	print(Items.size())

func removeItem(name):
	for Item in Items:
		if Item.name==name:
			Items.remove(Items.find(Item))

func loadAufgabe(number):
	for aufgabe in aufgabenbody:
		if(number==aufgabe[0]):
			return aufgabe[1]

func getActiveAufgabe():
	return Items[get_node("/root/global").getItemselected()].aufgabe

func isSolved(number):
	for aufgabe in aufgabenheader:
		if number==aufgabe[0]:
			var solved=true
			print("!!!!!!!!!!!!!!!!!",aufgabe[2])
			for status in aufgabe[2]:
				solved=solved and status
			return solved
	return false

func failedAufgabe(number):
	for aufgabe in aufgabenheader:
		if(number==aufgabe[0]):
			aufgabe[1][4]+=1
	

func gatherReward(number):
	for aufgabe in aufgabenheader:
		if(number==aufgabe[0]):
			Points+=get_node("/root/global").Prices[aufgabe[3]][0]/max(1,aufgabe[4])
			var type=calculatetype(aufgabenbody[number][1][10],aufgabenbody[number][1][12])
			leveltype[type]=leveltype[type]*1.25/pow(2,aufgabe[4])
			if(get_node("/root/global").Prices[aufgabe[3]].size()>1):
				get_node("/root/global").reward(get_node("/root/global").Prices[aufgabe[3]][1])
			get_node("/root/global").updateGui()

func deleteTools():
	for item in Items:
		if(item.name=="Tools1" or item.name=="Tools2"):
			Items.remove(Items.find(item))

func saveGame():
	var inventory=get_node("/root/import_export").exportInventory(Items)
	var quests=get_node("/root/import_export").exportAufgabenheader(aufgabenheader)
	var TDstate=get_node("/root/import_export").exportTDState(TDPlane)
	var Worldstate=get_node("/root/import_export").exportWorldState(changedWorldcells,changedWorldcellto)
	#Points,Resources,dialogsfinished,inventory,quests,tdmap,worldmap
	get_node("/root/import_export").exportMetadata(get_node("/root/global").getPlayerName(),Points,Resources,doneDialogs,actionsdone,leveltype,inventory,quests,TDstate,Worldstate)

func loadGame(number):
	var metadata=get_node("/root/import_export").importMetadata(number)
	get_node("/root/global").PlayerName=metadata[0]
	Points=metadata[1]
	Resources=metadata[2]
	doneDialogs=metadata[3]
	actionsdone=metadata[4]
	leveltype=metadata[5]
	ItemsLoading=get_node("/root/import_export").importInventory(metadata[6])
	print("ITEMSTOLOAD: ",ItemsLoading)
	aufgabenheader=get_node("/root/import_export").importAufgabenheader(metadata[7])
	TDPlane=get_node("/root/import_export").importTDState(metadata[8])
	var tmp=get_node("/root/import_export").importWorldState(metadata[9])
	changedWorldcells=tmp[0]
	changedWorldcellto=tmp[1]
	calculateNextDialogs()
	get_node("/root/global").updateGui()

func loadLastGame():
	var index=-1
	while(File.new().file_exists(str("Saves/save",index,".save"))):
		index+=1
	if(index > -1):
		loadGame(index)

func getDialogheader(value):
	return dialogheader[value][1]

func getDialogfooter(value):
	return dialogbody[value][1]

func set_status(var number, var status):
	for aufgabe in aufgabenheader:
		if aufgabe[0]==number:
			aufgabe[2]=status
	pass