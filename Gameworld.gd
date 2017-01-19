
extends WorldEnvironment
var ray
var Slots=[]
var iterator=0

var cameralocked=false
var changingwindows=false

var interfaceshowing=true

func _ready():
	# Initialization here
	print("Gameworldinit")
	set_process(true)
	get_node("GUI/Label").set_text(get_node("/root/global").getPlayerName())
#	Input.set_mouse_mode(2)
	ray=get_node("Characters/Maincharacter/Camerapointer/Camera/StaticBody/RayCast")
	var settings=get_node("/root/global").Settings
	if !settings.empty():
		if(settings[0]==0):
			get_tree().get_root().set_rect(Rect2(0,0,640,480))
		elif(settings[0]==1):
			get_tree().get_root().set_rect(Rect2(0,0,1024,768))
		elif(settings[0]==2):
			get_tree().get_root().set_rect(Rect2(0,0,1366,768))
		elif(settings[0]==3):
			get_tree().get_root().set_rect(Rect2(0,0,1440,900))
		elif(settings[0]==4):
			get_tree().get_root().set_rect(Rect2(0,0,1920,1200))
		get_node("Lights").set_project_shadows(settings[1])
		get_environment().set_enable_fx(2,settings[2])
		get_environment().set_enable_fx(3,settings[3])
		get_environment().set_enable_fx(1,settings[4])
		get_environment().set_enable_fx(4,settings[5])
	for i in range(10):
		var tf = TextureFrame.new()
		tf.set_pos(Vector2(40*i+2,2))
		tf.set_name(str("Slot",i))
		get_node("GUI/Quickslots").add_child(tf)
		Slots.push_back(tf)
	get_node("Characters/Maincharacter").loadCharacter(get_node("/root/import_export").importCharacter(str("player-",get_node("/root/global").PlayerName,".character")))
	get_node("Characters/Angie").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Angie.character")))
	get_node("Characters/Maurice").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Maurice.character")))
	get_node("Characters/Marja").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Marja.character")))
	get_node("Characters/Mina").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Mina.character")))
	get_node("Characters/Fritz").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Fritz.character")))
	get_node("Characters/Maik").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Maik.character")))
	get_node("Characters/Anja").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Anja.character")))
	get_node("Characters/Lucia").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Lucia.character")))
	get_node("Characters/Torben").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Torben.character")))
	get_node("Characters/Jessica").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Jessica.character")))
	get_node("Characters/Jay").loadCharacter(get_node("/root/import_export").importCharacter(str("Characters/Jay.character")))
	get_node("/root/global").updateGui()
	if !get_node("/root/savegame").changedWorldcellto.empty():
		loadWorldCells()
	if !get_node("/root/savegame").ItemsLoading.empty():
		var newItems=[]
		var oldItems=get_node("/root/savegame").ItemsLoading
		print("OLDITEMS: ",oldItems)
		for item in oldItems:
			print("GeneratingItems: from ",oldItems," taking ", item)
			var newItem=load("res://item.gd").new()
			newItem.generateItem(item[0],item[1],item[2])
			newItems.push_back(newItem)
		get_node("/root/savegame").Items=newItems
		get_node("/root/savegame").ItemsLoading=[]
	changingwindows=false
	if(get_node("/root/savegame").actionsdone[0]==false):
		get_node("GUI/PopupMenu2").popup()
		interfaceshowing=true
	updateTowervisibility()
#	get_node("Ocean").fixdistance(get_node("Characters/Maincharacter").get_translation())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("Gameworldinitdone")

func loadWorldCells():
	var map= get_node("Mapelements/Worldmap")
	for i in range(get_node("/root/savegame").changedWorldcellto.size()):
		var location=get_node("/root/savegame").changedWorldcells[i]
		map.set_cell_item(location.x,location.y,location.z,get_node("/root/savegame").changedWorldcellto[i])


func updateTowervisibility():
	get_node("Towerdefense/MeshInstance").set_hidden(!get_node("/root/savegame").actionsdone[1])
	get_node("Towerdefense/MeshInstance/Levelstarter").set_hidden(!get_node("/root/savegame").actionsdone[1])
	get_node("Houses/Fabrik/Towers1").set_hidden(!get_node("/root/savegame").actionsdone[2])
	get_node("Houses/Fabrik/Towers2").set_hidden(!get_node("/root/savegame").actionsdone[4])
	if(get_node("/root/savegame").actionsdone[2]):
		get_node("Houses/Fabrik/Towers1/Towers1").set_layer_mask(1)
	else:
		get_node("Houses/Fabrik/Towers1/Towers1").set_layer_mask(0)
	#print("AAAAAAAAAAAAAAXHTUNG")
	#get_node("Houses/Fabrik/Towers2/Towers2").print_tree()
	if(get_node("/root/savegame").actionsdone[4]):
		get_node("Houses/Fabrik/Towers2/Towers2").set_layer_mask(1)
	else:
		get_node("Houses/Fabrik/Towers2/Towers2").set_layer_mask(0)
func _process(delta):
	if(Input.is_action_pressed("ui_close")):
		get_tree().quit()
	if(Input.is_key_pressed(KEY_ESCAPE)):
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_node("GUI/PopupMenu").popup()
		interfaceshowing=true
#		set_pause_mode(PAUSE_MODE_STOP)
	if(ray.is_colliding() and Input.is_mouse_button_pressed(BUTTON_LEFT)):
		var col = ray.get_collider()
		if (col.get_name()=="Testcube"):
			if(not get_node("Testcube/TestCube").is_hidden()):
				get_node("Testcube/TestCube").hide()
			else:
				get_node("Testcube/TestCube").show()
#		elif ("Watercollider"==col.get_name()):
#			col.get_parent().drain(1)
		elif ("Staffelei"==col.get_name()):
			var selectedItem = null
			if (get_node("/root/savegame").Items.size()>get_node("/root/global").getItemselected()):
				selectedItem = get_node("/root/savegame").Items[get_node("/root/global").getItemselected()]
			#print("you are gonna do aufgabe: ",selectedItem.aufgabe)
			if(selectedItem!=null and selectedItem.aufgabe!=null):
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_node("/root/global").setScene("res://aufgabe.scn")
				changingwindows=true
#			print(get_node("/root/global").Items.size())
		elif ("Worldmap"==col.get_name() and (get_node("/root/savegame").getActiveName()=="Tool1" or get_node("/root/savegame").getActiveName()=="Tool2")):
			var point = ray.get_collision_point()
			var map= get_node("Mapelements/Worldmap")
			var save=get_node("/root/savegame")
			point.x=((point.x-map.get_center_x())/2)-0.5
			point.y=((point.y-map.get_center_y())/2)-0.5
			point.z=((point.z-map.get_center_z())/2)-0.5
			var pointmod=point-point.floor()
			var item=map.get_cell_item(point.x,point.y+1,point.z)
			var itemtl
			var itemtr
			var itembl
			var itembr
			var direction=Vector2(0,0)
			point=point.ceil()
			#print(point)
			#print(pointmod)
			#print(item)
			if(point.x<-17 or point.x>44 or point.z<-10):
				if (map.get_cell_item(point.x,point.y,point.z)==13 and get_node("/root/savegame").Resources>=2):
					map.set_cell_item(point.x,point.y,point.z,1,0)
					save.changedworldcell(Vector3(point.x,point.y,point.z),1)
					get_node("/root/savegame").Resources-=2
					get_node("/root/global").updateGui()
				if(pointmod.x>=0.5 and pointmod.z>=0.5):
					itemtl=map.get_cell_item(point.x,point.y,point.z)
					itembl=map.get_cell_item(point.x,point.y,point.z+1)
					itembr=map.get_cell_item(point.x+1,point.y,point.z+1)
					itemtr=map.get_cell_item(point.x+1,point.y,point.z)
					direction=Vector2(0,0)
				if(pointmod.x>=0.5 and pointmod.z<0.5):
					itembl=map.get_cell_item(point.x,point.y,point.z)
					itembr=map.get_cell_item(point.x+1,point.y,point.z)
					itemtr=map.get_cell_item(point.x+1,point.y,point.z-1)
					itemtl=map.get_cell_item(point.x,point.y,point.z-1)
					direction=Vector2(0,-1)
				if(pointmod.x<0.5 and pointmod.z<0.5):
					itembr=map.get_cell_item(point.x,point.y,point.z)
					itembl=map.get_cell_item(point.x-1,point.y,point.z)
					itemtl=map.get_cell_item(point.x-1,point.y,point.z-1)
					itemtr=map.get_cell_item(point.x,point.y,point.z-1)
					direction=Vector2(-1,-1)
				if(pointmod.x<0.5 and pointmod.z>=0.5):
					itemtr=map.get_cell_item(point.x,point.y,point.z)
					itembl=map.get_cell_item(point.x-1,point.y,point.z+1)
					itembr=map.get_cell_item(point.x,point.y,point.z+1)
					itemtl=map.get_cell_item(point.x-1,point.y,point.z)
					direction=Vector2(-1,0)
				#print("at1 ",itemtl,"/",itemtr,"/",itembl,"/",itembr)
				itemtl=get_up(itemtl)
				itemtr=get_up(itemtr)
				itembl=get_up(itembl)
				itembr=get_up(itembr)
				#print("at2 ",itemtl,"/",itemtr,"/",itembl,"/",itembr)
				#print(itemtl%2,"/",itemtr%4,"/",itembl%8,"/",itembr%16)
				#print(itembr%16<8,"/", 0%16<8)
				#print(itemtl%2<1,"/",itemtr%4<2,"/",itembl%8<4,"/",itembr%16<8,"/")
				var addstuff=false
				if(itemtl!=-1 and (itemtl%2)<1 and itemtr!=-1 and (itemtr%4)<2 and itembl!=-1 and (itembl%8)<4 and itembr!=-1 and (itembr%16)<8):
				#	print("success",itemtl,"/",itemtr,"/",itembl,"/",itembr)
					if(itemtl!=8 and itemtr!=4 and itembl!=2 and itembr!=1):
						addstuff=true
				if(addstuff==true and get_node("/root/savegame").Resources>=20):
					get_node("/root/savegame").Resources-=20
					get_node("/root/global").updateGui()
				#	print("at3 ",itemtl,"/",itemtr,"/",itembl,"/",itembr)
					itemtl+=1
					itemtr+=2
					itembl+=4
					itembr+=8
				#	print("at4 ",itemtl,"/",itemtr,"/",itembl,"/",itembr)
					map.set_cell_item(point.x+direction.x,point.y+floor(itemtl/15),point.z+direction.y,set_up(itemtl),0)
					save.changedworldcell(Vector3(point.x+direction.x,point.y+floor(itemtl/15),point.z+direction.y),set_up(itemtl))
					if(floor(itemtl/15)==1):
						map.set_cell_item(point.x+direction.x,point.y,point.z+direction.y,-1,0)
						save.changedworldcell(Vector3(point.x+direction.x,point.y,point.z+direction.y),-1)
					map.set_cell_item(point.x+direction.x+1,point.y+floor(itemtr/15),point.z+direction.y,set_up(itemtr),0)
					save.changedworldcell(Vector3(point.x+direction.x+1,point.y+floor(itemtr/15),point.z+direction.y),set_up(itemtr))
					if(floor(itemtr/15)==1):
						map.set_cell_item(point.x+direction.x+1,point.y,point.z+direction.y,-1,0)
						save.changedworldcell(Vector3(point.x+direction.x+1,point.y,point.z+direction.y),-1)
					map.set_cell_item(point.x+direction.x,point.y+floor(itembl/15),point.z+direction.y+1,set_up(itembl),0)
					save.changedworldcell(Vector3(point.x+direction.x,point.y+floor(itembl/15),point.z+direction.y+1),set_up(itembl))
					if(floor(itembl/15)==1):
						map.set_cell_item(point.x+direction.x,point.y,point.z+direction.y+1,-1,0)
						save.changedworldcell(Vector3(point.x+direction.x,point.y,point.z+direction.y+1),-1)
					map.set_cell_item(point.x+direction.x+1,point.y+floor(itembr/15),point.z+direction.y+1,set_up(itembr),0)
					save.changedworldcell(Vector3(point.x+direction.x+1,point.y+floor(itembr/15),point.z+direction.y+1),set_up(itembr))
					if(floor(itembr/15)==1):
						map.set_cell_item(point.x+direction.x+1,point.y,point.z+direction.y+1,-1,0)
						save.changedworldcell(Vector3(point.x+direction.x+1,point.y,point.z+direction.y+1),-1)
		elif("Towerdefensemap"==col.get_name()):
			var point = ray.get_collision_point()
			var td=get_node("Towerdefense")
			td.click(-(point.z-td.get_translation().z)/2,-(point.x-td.get_translation().x)/2)
			#print("done: ",td.get_node("Water").endIsReachable()," ",iterator)
		elif(col.get_parent().get_name()=="Characters"):
			if get_node("GUI/Dialogwindow").is_hidden():
				get_node("GUI/Dialogwindow").showdialog(get_node("/root/savegame").getNextDialogFor(col.name)[1],get_node("/root/savegame").getNextDialogFor(col.name)[0])
				col.absolutepause=true
				interfaceshowing=true
			#var quest=col.getQuest()
			#if(quest!=null and get_node("/root/savegame").Items.find(quest)==-1):
			#	get_node("/root/savegame").Items.push_back(quest)
			#	get_node("/root/global").updateGui()
		elif(col.get_name()=="Towers1"):
			get_node("GUI/PopupMenu3").popup()
			interfaceshowing=true
			get_node("GUI/PopupMenu3").updategui()
		elif(col.get_name()=="Magiccube" and !get_node("/root/savegame").actionsdone[2]):
			
			var tower1=load("res://item.gd").new()
			tower1.generateItem(null,"res://textures/gatherer-tower.png","sammlerturm")
			get_node("/root/savegame").addItem(tower1)
			
#			var tower1=load("res://item.gd").new()
#			tower1.generateItem(null,"res://textures/gatherer-tower.png","sammlerturm")
#			get_node("/root/savegame").addItem(tower1)
			
			var tower2=load("res://item.gd").new()
			tower2.generateItem(null,"res://textures/abfluss-tower.png","abflussturm")
			get_node("/root/savegame").addItem(tower2)
			
			get_node("/root/global").reward("Door")
			get_node("/root/global").reward("Hälfte1")
			get_node("/root/global").reward("Tools1")
			
			get_node("/root/savegame").Resources+=1000
			get_node("/root/global").updateGui()
		elif(col.get_name()=="Levelstarter"):
			get_node("GUI/PopupMenu1").popup()
			interfaceshowing=true
		
		else:
			print(col.get_name())
	get_node("GUI/Quickslots/Selected").set_pos(Vector2(-2+40*get_node("/root/global").getItemselected(),-2))
#	if(Input.is_key_pressed(KEY_R)):
#		print("keypress: ",get_node("Towerdefense/Water").endIsReachable()," ",iterator)
#		iterator+=1
	for i in range(get_node("/root/savegame").Items.size()):
		print(i, get_node("/root/savegame").Items)
		if(Slots.size()>i):
			Slots[i].set_texture(get_node("/root/savegame").getItem(i).icon)
	if(Slots.size()>get_node("/root/savegame").Items.size()):
		Slots[get_node("/root/savegame").Items.size()].set_texture(null)
	get_node("GUI/Playericon").set_pos(Vector2((get_node("Characters/Maincharacter").get_translation().x+40)/2,(get_node("Characters/Maincharacter").get_translation().z+228)/2))
	
	
	#var distance = get_node("Ocean").get_translation()-get_node("Characters/Maincharacter").get_translation()
	#distance.x=-distance.x
	#distance/=20
	#distance.x=floor(distance.x)
	#distance.y=floor(distance.y)
	#distance.z=floor(distance.z)
	#print(distance)
	#if(distance.x<4 or distance.x>6 or distance.z<4 or distance.z>6):
	#	get_node("Ocean").fixdistance(get_node("Characters/Maincharacter").get_translation())
	if (get_node("Characters").ctrlpressed):
		interfaceshowing=true
	elif(!get_node("GUI/Dialogwindow").is_visible() and !get_node("GUI/PopupMenu").is_visible() and !get_node("GUI/PopupMenu1").is_visible() and !get_node("GUI/PopupMenu2").is_visible() and !get_node("GUI/PopupMenu3").is_visible() and !get_node("GUI/PopupMenu4").is_visible() and !get_node("GUI/PopupMenu5").is_visible()):
		interfaceshowing=false
	# changingwindows or get_node("Characters").ctrlpressed or get_node("GUI/Dialogwindow").is_visible() or get_node("GUI/PopupMenu").is_visible() or get_node("GUI/PopupMenu1").is_visible() or get_node("GUI/PopupMenu2").is_visible() or get_node("GUI/PopupMenu3").is_visible() or get_node("GUI/PopupMenu4").is_visible()
	if(interfaceshowing):
		if Input.get_mouse_mode()!=Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_node("Characters").set_fixed_process(false)
	else:
		if Input.get_mouse_mode()!=Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_node("Characters").set_fixed_process(true)

func get_up(i):
	if(i==-1):
		return -1
	elif(i==0):
		return 2
	elif(i==1):
		return 0
	elif(i==2):
		return 10
	elif(i==3):
		return 12
	elif(i==4):
		return 4
	elif(i==5):
		return 5
	elif(i==6):
		return 1
	elif(i==7):
		return 3
	elif(i==8):
		return 8
	elif(i==9):
		return 7
	elif(i==10):
		return 11
	elif(i==11):
		return 14
	elif(i==12):
		return 13
	elif(i==13):
		return -1

func set_up(i):
	if(i==0 or i==15):
		return 1
	elif(i==1):
		return 6
	elif(i==2):
		return 0
	elif(i==3):
		return 7
	elif(i==4):
		return 4
	elif(i==5):
		return 5
	elif(i==7):
		return 9
	elif(i==8):
		return 8
	elif(i==10):
		return 2
	elif(i==11):
		return 10
	elif(i==12):
		return 3
	elif(i==13):
		return 12
	elif(i==14):
		return 11
	else:
		return 1