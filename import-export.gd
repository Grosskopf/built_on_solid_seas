
extends Node

var file=File.new()

func _ready():
	pass

func exportInventory( items ):
	var index=0
	while(file.file_exists(str("Saves/info/inventory",index,".info"))):
		index+=1
	var filename=str("Saves/info/inventory",index,".info")
	file.open(filename,file.WRITE)
	for item in items:
		file.store_line(str(item.aufgabe))
		file.store_line(item.icon.get_path())
		file.store_line(item.name)
	file.close()
	return filename

#nummer, dateiname, status, reward und versuche
func exportAufgabenheader( header ):
	var index=0
	while(file.file_exists(str("Saves/info/aufgheader",index,".info"))):
		index+=1
	var filename=str("Saves/info/aufgheader",index,".info")
	file.open(filename,file.WRITE)
	for aufgabe in header:
		file.store_line("Aufgabenummer:")
		file.store_line(str(aufgabe[0]))
		file.store_line("Datei:")
		file.store_line(aufgabe[1])
		file.store_line("Status:")
		for status in aufgabe[2]:
			file.store_line(str(status))
		file.store_line("Reward:")
		file.store_line(str(aufgabe[3]))
		file.store_line("Versuche:")
		file.store_line(str(aufgabe[4]))
	file.close()
	return filename

func exportTDState( info ):
	var index=0
	while(file.file_exists(str("Saves/info/tdstate",index,".info"))):
		index+=1
	var filename=str("Saves/info/tdstate",index,".info")
	file.open(filename,file.WRITE)
	for infopart in info:
		file.store_line(str(infopart[0].x))
		file.store_line(str(infopart[0].y))
		file.store_line(str(infopart[1].x))
		file.store_line(str(infopart[1].y))
	file.close()
	return filename

func exportWorldState( positions , states ):
	var index=0
	while(file.file_exists(str("Saves/info/worldstate",index,".info"))):
		index+=1
	var filename=str("Saves/info/worldstate",index,".info")
	file.open(filename,file.WRITE)
	for i in range(positions.size()):
		file.store_line(str(positions[i].x))
		file.store_line(str(positions[i].y))
		file.store_line(str(positions[i].z))
		file.store_line(str(states[i]))
	file.close()
	return filename

func exportMetadata(Name,Points,Resources,dialogsfinished,actionsdone,leveltype,inventory,quests,tdmap,worldmap):
	var index=0
	while(file.file_exists(str("Saves/save",index,".save"))):
		index+=1
	var filename=str("Saves/save",index,".save")
	file.open(filename,file.WRITE)
	file.store_line(str(Name))
	file.store_line(str(Points))
	file.store_line(str(Resources))
	for dialogsf in dialogsfinished:
		file.store_line(str(dialogsf))
	file.store_line("Actionsdone:")
	for actionbool in actionsdone:
		file.store_line(str(actionbool))
	file.store_line("Leveltype:")
	for level in leveltype:
		file.store_line(str(level))
	file.store_line("Inventory:")
	file.store_line(inventory)
	file.store_line(quests)
	file.store_line(tdmap)
	file.store_line(worldmap)
	file.close()

func importMetadata(index):
	file.open(str("Saves/save",index,".save"),file.READ)
	#Points,Resources,dialogsfinished,inventory,quests,tdmap,worldmap
	var info=["",0,0,[],[],[],"","","",""]
	info[0]=file.get_line()
	info[1]=int(file.get_line())
	info[2]=int(file.get_line())
	var line=file.get_line()
	while(line!="Actionsdone:"):
		info[3].push_back(int(line))
		line=file.get_line()
		print("in dialog")
	line=file.get_line()
	while(line!="Leveltype:"):
		info[4].push_back(line=="True")
		line=file.get_line()
		print("In actions")
	line=file.get_line()
	while(line!="Inventory:"):
		info[5].push_back(line=="True")
		print("in last")
		line=file.get_line()
	info[6]=file.get_line()
	info[7]=file.get_line()
	info[8]=file.get_line()
	info[9]=file.get_line()
	file.close()
	return info

func importInventory(filename):
	file.open(filename,file.READ)
	var info=[]
	while(!file.eof_reached()):
		var tmp=[]
		tmp.push_back(int(file.get_line()))
		tmp.push_back(file.get_line())
		tmp.push_back(file.get_line())
		info.push_back(tmp)
	file.close()
	info.resize(info.size()-1)
	print(info)
	
	return info

func importAufgabenheader(filename):
	file.open(filename,file.READ)
	var info=[]
	var aufgabe=[0,"",[],0,0]
	var status=false
	while(!file.eof_reached()):
		var line=file.get_line()
		if(line=="Aufgabenummer:"):
			aufgabe[0]=int(file.get_line())
		elif(line=="Datei:"):
			aufgabe[1]=file.get_line()
		elif(line=="Status:"):
			status=true
		elif(line=="Reward:"):
			aufgabe[3]=int(file.get_line())
			status=false
		elif(line=="Versuche:"):
			aufgabe[4]=int(file.get_line())
			info.push_back(aufgabe)
			aufgabe=[0,"",[],0,0]
		elif(status):
			aufgabe[2].push_back(line=="True")
		
	file.close()
	return info

func importTDState(filename):
	file.open(filename,file.READ)
	var info=[]
	while(!file.eof_reached()):
		info.push_back([Vector2(float(file.get_line()),float(file.get_line())),Vector2(float(file.get_line()),float(file.get_line()))])
		print("loading ",info[info.size()-1])
	file.close()
	info.resize(info.size()-1)
	return info

func importWorldState(filename):
	file.open(filename,file.READ)
	var info=[[],[]]
	while(!file.eof_reached()):
		info[0].push_back(Vector3(float(file.get_line()),float(file.get_line()),float(file.get_line())))
		info[1].push_back(float(file.get_line()))
	info[0].resize(info[0].size()-1)
	info[1].resize(info[1].size()-1)
	file.close()
	return info

func exportDialog(filename,dialog):
	file.open(filename,file.WRITE)
	file.store_line("CharacterName:")
	file.store_line(dialog[0][0])
	file.store_line("Dependencies:")
	for dependencies in dialog[0][1]:
		file.store_line(str(dependencies))
	file.store_line("Dependenciespoints:")
	file.store_line(str(dialog[0][2]))
	file.store_line("Actions:")
	file.store_line(str(dialog[0][3]))
	file.store_line("Mainfield:")
	file.store_line(dialog[1][0])
	file.store_line("AnswerW:")
	file.store_line(dialog[1][1])
	file.store_line("AnswerA:")
	file.store_line(dialog[1][2])
	file.store_line("AnswerD:")
	file.store_line(dialog[1][3])
	file.store_line("Backtalk1:")
	file.store_line(dialog[1][4])
	file.store_line("Backtalk2:")
	file.store_line(dialog[1][5])
	file.store_line("Item1:")
	file.store_line(str(dialog[1][6][0]))
	file.store_line(dialog[1][6][1])
	file.store_line(dialog[1][6][2])
	file.store_line("Item2:")
	file.store_line(str(dialog[1][7][0]))
	file.store_line(dialog[1][7][1])
	file.store_line(dialog[1][7][2])
	file.store_line("Type:")
	file.store_line(str(dialog[1][8]))
	file.close()
	pass

func importDialog(filename):
	var dialog=[["",[],0,0],["", "","","", "","", [0,"",""],[0,"",""], -1]]
	file.open(filename,file.READ)
	var mode=-1
	while(!file.eof_reached()):
		var line=file.get_line()
		if(line=="CharacterName:"):
			dialog[0][0]=file.get_line()
		elif(line=="Dependencies:"):
			mode=1
		elif(line=="Dependenciespoints:"):
			dialog[0][2]=int(file.get_line())
		elif(line=="Action:"):
			dialog[0][3]=int(file.get_line())
		elif(line=="Mainfield:"):
			mode=0
		elif(line=="AnswerW:"):
			dialog[1][1]=file.get_line()
		elif(line=="AnswerA:"):
			dialog[1][2]=file.get_line()
		elif(line=="AnswerD:"):
			dialog[1][3]=file.get_line()
		elif(line=="Backtalk1:"):
			mode=4
		elif(line=="Backtalk2:"):
			mode=5
		elif(line=="Item1:"):
			dialog[1][6][0]=int(file.get_line())
			dialog[1][6][1]=str("textures/Icons/",file.get_line())
			dialog[1][6][2]=file.get_line()
		elif(line=="Item2:"):
			dialog[1][7][0]=int(file.get_line())
			dialog[1][7][1]=str("textures/Icons/",file.get_line())
			dialog[1][7][2]=file.get_line()
		elif(line=="Type:"):
			dialog[1][8]=int(file.get_line())
		else:
			if(mode==1):
				dialog[0][1].push_back(int(line))
			elif(mode!=-1):
				dialog[1][mode]=str(dialog[1][mode],line)
	return dialog
	pass



func importBlueprint(var filename):
	
	var blueprint=["",[],[],[],[],[],[],[],[],false,0,0,[],"","",0]
	file.open(filename,file.READ)
	var mode=0
	while(!file.eof_reached()):
		#print(filename)
		var line= file.get_line()
		if(line=="Image:"):
			blueprint[0]=file.get_line()
		elif(line=="Points:"):
			mode=1
		elif(line=="Lines:"):
			mode=2
		elif(line=="Circles:"):
			mode=3
		elif(line=="Circleparts:"):
			mode=4
		elif(line=="Aufgaben:"):
			mode=5
		elif(line=="OtherLabels:"):
			mode=6
		elif(line=="SeesAngles:"):
			mode=7
		elif(line=="SeesLength:"):
			mode=8
		elif(line=="ActivatedMeasuring:"):
			blueprint[9]=bool(file.get_line())
		elif(line=="Chapter:"):
			blueprint[10]=int(file.get_line())
		elif(line=="Difficulty:"):
			blueprint[11]=int(file.get_line())
		elif(line=="Challenges:"):
			mode=12
		elif(line=="Questtext:"):
			mode=13
		elif(line=="Character:"):
			blueprint[14]=file.get_line()
		elif(line=="Price:"):
			blueprint[15]=int(file.get_line())
		else:
			if(mode==1):
				blueprint[1].push_back(Vector2(int(line),int(file.get_line())))
			elif(mode==4):
				blueprint[4].push_back(Vector2(int(line),int(file.get_line())))
				blueprint[4].push_back(Vector3(int(file.get_line()),int(file.get_line()),int(file.get_line())))
			elif(mode==7 or mode==8 or mode==12):
				blueprint[mode].push_back(line=="True")
			elif(mode==13):
				blueprint[13]=str(blueprint[13],line,"\n")
			elif(mode!=0):
				blueprint[mode].push_back(Vector3(int(line),int(file.get_line()),float(file.get_line())))
	file.close()
	#print("done")
	return blueprint

func exportBlueprint(filename, blueprint):
	file.open(str("Aufgaben/",filename,".aufgabe"),file.WRITE)
	file.store_line("Image:")
	file.store_line(blueprint[0])
	file.store_line("Points:")
	for Point in blueprint[1]:
		file.store_line(str(Point.x))
		file.store_line(str(Point.y))
	file.store_line("Lines:")
	for Line in blueprint[2]:
		file.store_line(str(Line.x))
		file.store_line(str(Line.y))
		file.store_line(str(Line.z))
	file.store_line("Circles:")
	for Circle in blueprint[3]:
		file.store_line(str(Circle.x))
		file.store_line(str(Circle.y))
		file.store_line(str(Circle.z))
	file.store_line("Circleparts:")
	for i in range(blueprint[4].size()/2):
		file.store_line(str(blueprint[4][i*2].x))
		file.store_line(str(blueprint[4][i*2].y))
		file.store_line(str(blueprint[4][i*2+1].x))
		file.store_line(str(blueprint[4][i*2+1].y))
		file.store_line(str(blueprint[4][i*2+1].z))
	file.store_line("Aufgaben:")
	for aufgabe in blueprint[5]:
		file.store_line(str(aufgabe.x))
		file.store_line(str(aufgabe.y))
		file.store_line(str(aufgabe.z))
	file.store_line("OtherLabels:")
	for otherlabel in blueprint[6]:
		file.store_line(str(otherlabel.x))
		file.store_line(str(otherlabel.y))
		file.store_line(str(otherlabel.z))
	file.store_line("SeesAngles:")
	for angleVis in blueprint[7]:
		file.store_line(str(angleVis))
	file.store_line("SeesLength:")
	for lengthVis in blueprint[8]:
		file.store_line(str(lengthVis))
	file.store_line("ActivatedMeasuring:")
	file.store_line(str(blueprint[9]))
	file.store_line("Chapter:")
	file.store_line(str(blueprint[10]))
	file.store_line("Difficulty:")
	file.store_line(str(blueprint[11]))
	file.store_line("Challenges:")
	for challenges in blueprint[12]:
		file.store_line(str(challenges))
	file.store_line("Questtext:")
	file.store_line(str(blueprint[13]))
	file.store_line("Character:")
	file.store_line(str(blueprint[14]))
	file.store_line("Price:")
	file.store_line(str(blueprint[15]))
	file.close()
	
	

func exportCharacter(var name, var character ):
	file.open(str("player-",name,".character"),file.WRITE)
	file.store_line(character.name)
	if(character.hairstyle!=""):
		file.store_line(character.hairstyle)
	else:
		file.store_line("null")
	if(character.clothing!=""):
		file.store_line(character.clothing)
	else:
		file.store_line("null")
	file.store_line(str(character.lowerbodywidth-0.5))
	file.store_line(str(character.upperbodywidth-0.5))
	file.store_line(str((character.shoulderwidth-0.5)*2))
	file.store_line(str((character.bodyheight-0.75)*2))
	file.store_line(str(character.headwidth-0.5))
	file.store_line(str(character.headheight-0.5))
	file.store_line(character.skincolor.to_html())
	file.store_line(character.haircolor.to_html())
	file.store_line(character.eyecolor.to_html())
	file.close()
	
func importCharacter(var name):
	var Character=ResourceLoader.load("res://character.scn").instance()
	file.open(name,file.READ)
	var tmp
	tmp=file.get_line()
	Character.setValue(0,tmp)
	tmp=file.get_line()
	if(tmp=="null"):
		tmp=""
	Character.setValue(1,tmp)
	tmp=file.get_line()
	Character.setValue(2,tmp)
	tmp=file.get_line()
	tmp=float(tmp)
	Character.setValue(3,tmp)
	tmp=file.get_line()
	tmp=float(tmp)
	Character.setValue(4,tmp)
	tmp=file.get_line()
	tmp=float(tmp)
	Character.setValue(5,tmp)
	tmp=file.get_line()
	tmp=float(tmp)
	Character.setValue(6,tmp)
	tmp=file.get_line()
	tmp=float(tmp)
	Character.setValue(7,tmp)
	tmp=file.get_line()
	tmp=float(tmp)
	Character.setValue(8,tmp)
	tmp=file.get_line()
	tmp=Color(tmp)
	Character.setValue(9,tmp)
	tmp=file.get_line()
	tmp=Color(tmp)
	Character.setValue(10,tmp)
	tmp=file.get_line()
	tmp=Color(tmp)
	Character.setValue(11,tmp)
	file.close()
	return Character