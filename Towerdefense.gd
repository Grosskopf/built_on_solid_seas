
extends Spatial

var lastpoint=null
var wallpieces=[]
var lastwallpiece
var drains=[]
var level=[[50,[Vector3(0,2,2.5),Vector3(5,1,2.5)],[Vector2(3,2),Vector2(7,4)]],[100,[Vector3(0,2,5),Vector3(5,1,5)],[Vector2(3,2),Vector2(7,4)]],[200,[Vector3(0,2,10),Vector3(5,1,5)],[Vector2(3,2),Vector2(7,4)]]]
var leveltimer=-1
var running=false
var levelrunning=0
var backup=[[],[]]

func _ready():
	#startlevel()
	set_fixed_process(true)
	if(!get_node("/root/savegame").TDPlane.empty()):
		loadTDPlane()
	
	pass

func loadTDPlane():
	for i in range(get_node("Water").towers.size()):
		if(i>0):
			remove_child(get_node(str("Tower",i)))
	for i in range(get_node("Water").drainpoints.size()):
		if(i>0):
			remove_child(get_node(str("Drain",i)))
	get_node("Water").towers=[]
	get_node("Water").drainpoints=[]
	while(get_node("Wallpieces").get_child_count()!=0):
		get_node("Wallpieces").remove_child(get_node("Wallpieces").get_child(0))
	wallpieces=[]
	drains=[]
	var Loadarray=get_node("/root/savegame").TDPlane
	print("LOADING: ",Loadarray)
	for elements in range(Loadarray.size()):
		
		#print("elements ",Loadarray," ***** ",Loadarray[elements]," ***** ", elements)
		var actual=Loadarray[elements]
		
		if actual[1].x==0:
			var wallpiece=get_node("Wall").duplicate(true)
			wallpiece.show()
			get_node("Wallpieces").add_child(wallpiece)
			wallpiece.set_name(str("Wall_",actual[0].x,"_",actual[0].y,"_",actual[0].x,"_",actual[0].y))
			wallpiece.set_translation(Vector3(-2*actual[0].y,0,-2*actual[0].x))
			if(actual[0].y>0 and actual[0].y<19):
				get_node(str("Water/Cube_",actual[0].x-1,"_",actual[0].y)).neighbours[1]=null
				get_node(str("Water/Cube_",actual[0].x-1,"_",actual[0].y)).hasneighbours[1]=false
				get_node(str("Water/Cube_",actual[0].x,"_",actual[0].y)).neighbours[3]=null
				get_node(str("Water/Cube_",actual[0].x,"_",actual[0].y)).hasneighbours[3]=false
			wallpieces.push_back(actual[0])
			wallpieces.push_back(actual[0]+Vector2(0,1))
			print("Added wall: ",actual)
		elif actual[1].x==1:
			var wallpiece=get_node("Wall").duplicate(true)
			wallpiece.show()
			get_node("Wallpieces").add_child(wallpiece)
			wallpiece.set_name(str("Wall_",actual[0].x,"_",actual[0].y,"_",actual[0].x,"_",actual[0].y))
			wallpiece.set_translation(Vector3(-2*actual[0].y,0,-2*actual[0].x))
			wallpiece.rotate_y(PI/2)
			if(actual[0].y>0 and actual[0].y<19):
				get_node(str("Water/Cube_",actual[0].x,"_",actual[0].y-1)).neighbours[0]=null
				get_node(str("Water/Cube_",actual[0].x,"_",actual[0].y-1)).hasneighbours[0]=false
				get_node(str("Water/Cube_",actual[0].x,"_",actual[0].y)).neighbours[2]=null
				get_node(str("Water/Cube_",actual[0].x,"_",actual[0].y)).hasneighbours[2]=false
			wallpieces.push_back(actual[0])
			wallpieces.push_back(actual[0]+Vector2(1,0))
			print("Added wall: ",actual)
		elif actual[1].x==3:
			addDrain(actual[0])
	for elements in range(Loadarray.size()):
		if Loadarray[elements][1].x==2:
			var isblocked=[false,false,false,false]
			for i in range(wallpieces.size()/2):
				if(wallpieces[i*2]==Loadarray[elements][0]):
					if(wallpieces[i*2].y<wallpieces[i*2+1].y):
						isblocked[1]=true
					else:
						isblocked[0]=true
				elif(wallpieces[i*2+1]==Loadarray[elements][0]):
					if(wallpieces[i*2].y<wallpieces[i*2+1].y):
						isblocked[3]=true
					else:
						isblocked[2]=true
			add_tower(Loadarray[elements][0],isblocked)
	

func add_tower(newpoint,isblocked):
	var towers=get_node("Water").towers
	var tower=get_node("Tower0")
	if(!towers.empty()):
		tower=tower.duplicate(true)
	tower.set_translation(Vector3(-2*newpoint.y,2,-2*newpoint.x))
	tower.set_hidden(false)
	print(isblocked)
	tower.setsurroundingwalls(isblocked)
	tower.set_name(str("Tower",towers.size()))
	if(!towers.empty()):
		add_child(tower)
	var actower=Vector3(newpoint.x,newpoint.y,1)
	get_node("Water").towers.push_back(actower)
	get_node("/root/savegame").changedTDPlane(newpoint,2,0)
	pass

func _fixed_process(delta):
	if(running):
		if(!level[levelrunning][1].empty()):
			
			for waterac in level[levelrunning][1]:
				if(leveltimer>waterac.x):
					get_node("Water/Cube_0_0").drain(-waterac.y)
					get_node("Water").active=true
					if(leveltimer>waterac.x+waterac.z):
						level[levelrunning][1].pop_front()
		if(!level[levelrunning][2].empty()):
			if(leveltimer>level[levelrunning][2][0].x):
				get_node("Water").addbottles(level[levelrunning][2][0].y)
				level[levelrunning][2].pop_front()
		if(level[levelrunning][1].empty() and level[levelrunning][2].empty() and (!get_node("Water").active or get_node("Water").undermin)):
			endlevel()
		leveltimer+=delta
		

func startlevel(tostart):
	levelrunning=tostart
	running=true
	backup[0]=level[levelrunning][1]
	backup[1]=level[levelrunning][2]
	get_node("Water").won=true

func endlevel():
	running=false
	level[levelrunning][1]=backup[0]
	level[levelrunning][2]=backup[1]
	if(get_node("Water").won==true):
		get_node("/root/savegame").Resources+=level[levelrunning][0]
		get_node("/root/global").updateGui()
		get_parent().get_node("GUI/PopupMenu4").popup()
		get_parent().get_node("GUI/PopupMenu4").setto(str("Glückwunsch, du hast das Level gewonnen und ",level[levelrunning][0]," Resourcen gesammelt"),false)
		print("Congratulations, you won!")
	else:
		get_parent().get_node("GUI/PopupMenu4").popup()
		get_parent().get_node("GUI/PopupMenu4").setto("Du hast das Level wohl nicht geschafft, probier erstmal etwas leichteres",false)

func add_wall(newpoint,lastpoint):
	
	var isset=false
	for i in range(wallpieces.size()/2):
		if((wallpieces[i*2]==lastpoint and wallpieces[i*2+1]==newpoint)):
			get_node(str("Wallpieces/Wall_",lastpoint.x,"_",lastpoint.y,"_",newpoint.x,"_",newpoint.y)).rebuild()
			isset=true
	if(!isset):
		var wallpiece=get_node("Wall").duplicate(true)
		wallpiece.show()
		get_node("Wallpieces").add_child(wallpiece)
		wallpiece.set_name(str("Wall_",lastpoint.x,"_",lastpoint.y,"_",newpoint.x,"_",newpoint.y))
		wallpiece.set_translation(Vector3(-2*lastpoint.y,0,-2*lastpoint.x))
		#print("HEEERE")
		if(newpoint.x>lastpoint.x):
			wallpiece.rotate_y(PI/2)
		if(lastpoint.x<newpoint.x and lastpoint.y>0 and lastpoint.y<19):
			get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y-1)).neighbours[0]=null
			get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y-1)).hasneighbours[0]=false
			get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y)).neighbours[2]=null
			get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y)).hasneighbours[2]=false
		elif(lastpoint.y<newpoint.y and lastpoint.x>0 and lastpoint.x<19):
			get_node(str("Water/Cube_",lastpoint.x-1,"_",lastpoint.y)).neighbours[1]=null
			get_node(str("Water/Cube_",lastpoint.x-1,"_",lastpoint.y)).hasneighbours[1]=false
			get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y)).neighbours[3]=null
			get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y)).hasneighbours[3]=false
		if(!get_node("Water").endIsReachable()):
			get_node("Wallpieces").remove_child(wallpiece)
			if(lastpoint.x<newpoint.x and lastpoint.y>0 and lastpoint.y<19):
				get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y-1)).neighbours[0]=get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y))
				get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y-1)).hasneighbours[0]=true
				get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y)).neighbours[2]=get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y-1))
				get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y)).hasneighbours[2]=true
			elif(lastpoint.y<newpoint.y and lastpoint.x>0 and lastpoint.x<19):
				get_node(str("Water/Cube_",lastpoint.x-1,"_",lastpoint.y)).neighbours[1]=get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y))
				get_node(str("Water/Cube_",lastpoint.x-1,"_",lastpoint.y)).hasneighbours[1]=true
				get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y)).neighbours[3]=get_node(str("Water/Cube_",lastpoint.x-1,"_",lastpoint.y))
				get_node(str("Water/Cube_",lastpoint.x,"_",lastpoint.y)).hasneighbours[3]=true
		else:
			wallpieces.push_back(lastpoint)
			wallpieces.push_back(newpoint)
			if(lastpoint.y<newpoint.y):
				get_node("/root/savegame").changedTDPlane(lastpoint,0,-1)
			else:
				get_node("/root/savegame").changedTDPlane(lastpoint,1,-1)
	var tmpint=-1
	for tower in get_node("Water").towers:
		if tower.x==lastpoint.x and tower.y==lastpoint.y:
			tmpint=get_node("Water").towers.find(tower)
	if(tmpint!=-1):
		var isblocked=[false,false,false,false]
		for i in range(wallpieces.size()/2):
			if(wallpieces[i*2]==lastpoint):
				if(wallpieces[i*2].y<wallpieces[i*2+1].y):
					isblocked[1]=true
				else:
					isblocked[0]=true
			elif(wallpieces[i*2+1]==lastpoint):
				if(wallpieces[i*2].y<wallpieces[i*2+1].y):
					isblocked[3]=true
				else:
					isblocked[2]=true
		get_node(str("Tower",tmpint)).setsurroundingwalls(isblocked)
	tmpint=-1
	for tower in get_node("Water").towers:
		if tower.x==newpoint.x and tower.y==newpoint.y:
			tmpint=get_node("Water").towers.find(tower)
	if(tmpint!=-1):
		var isblocked=[false,false,false,false]
		for i in range(wallpieces.size()/2):
			if(wallpieces[i*2]==newpoint):
				if(wallpieces[i*2].y<wallpieces[i*2+1].y):
					isblocked[1]=true
				else:
					isblocked[0]=true
			elif(wallpieces[i*2+1]==newpoint):
				if(wallpieces[i*2].y<wallpieces[i*2+1].y):
					isblocked[3]=true
				else:
					isblocked[2]=true
		get_node(str("Tower",tmpint)).setsurroundingwalls(isblocked)
	get_node("Water").calculatePath()
	return !isset

func addDrain(newpoint):
	print("Added Drain to", newpoint)
	var drain=get_node("Drain0")
	if(!drains.empty()):
		drain=drain.duplicate(true)
	drain.set_translation(Vector3(-2*newpoint.y,0,-2*newpoint.x))
	drain.set_hidden(false)
	drain.set_name(str("Drain",drains.size()))
	drains.push_back(Vector3(newpoint.x,newpoint.y,0.05))
	if(!drains.empty()):
		add_child(drain)
	get_node("Water").drainpoints.push_back(Vector3(newpoint.x,newpoint.y,0.2))
	get_node("/root/savegame").changedTDPlane(newpoint,3,0)
	pass
	
func getDrainPower(field):
	for vec in drains:
		if vec.x==field.x and vec.y==field.y:
			return vec.z
	return -1
	pass

func click(var x, var y):
	
	var hand=get_node("/root/savegame").getActiveName()
	#print ("Hand:",hand,"- ")
	
	if hand=="abflussturm":
		var newpoint=Vector2(floor(x),floor(y))
		if(getDrainPower(newpoint)==-1):
			addDrain(newpoint)
			get_node("/root/savegame").removeActiveItem()
	elif hand=="sammlerturm":
		var newpoint=Vector2(floor(x+0.5),floor(y+0.5))
		var tmpint=-1
		for tower in get_node("Water").towers:
			if tower.x==newpoint.x and tower.y==newpoint.y:
				tmpint=get_node("Water").towers.find(tower)
		if(tmpint==-1 and wallpieces.find(newpoint)!=-1):
			var isblocked=[false,false,false,false]
			for i in range(wallpieces.size()/2):
				if(wallpieces[i*2]==newpoint):
					if(wallpieces[i*2].y<wallpieces[i*2+1].y):
						isblocked[1]=true
					else:
						isblocked[0]=true
				elif(wallpieces[i*2+1]==newpoint):
					if(wallpieces[i*2].y<wallpieces[i*2+1].y):
						isblocked[3]=true
					else:
						isblocked[2]=true
			add_tower(newpoint,isblocked)
			get_node("/root/savegame").removeActiveItem()
	elif hand=="Tool1" or hand =="Tool2":
		if(lastpoint==null):
			lastpoint=Vector2(floor(x+0.5),floor(y+0.5))
		else:
			var newpoint=Vector2(floor(x+0.5),floor(y+0.5))
			if(abs(newpoint.x-lastpoint.x)+abs(newpoint.y-lastpoint.y)==1):
				if(newpoint.x<lastpoint.x or newpoint.y<lastpoint.y):
					var tmp=newpoint
					newpoint=lastpoint
					lastpoint=tmp
				#print("ADDINGWALLS")
				if(get_node("/root/savegame").Resources>=10*get_node("Wallpieces").get_child_count()/2):
					if(add_wall(newpoint,lastpoint)):
						get_node("/root/savegame").Resources-=10*get_node("Wallpieces").get_child_count()/2
						get_node("/root/global").updateGui()
			lastpoint=newpoint
	pass
