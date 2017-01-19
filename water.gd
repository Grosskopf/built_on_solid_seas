
extends Spatial
#var cubes=[]
var active=false
var undermin=false
var dirtyneighbours=true
var drainpoints=[]

var heights=[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
var difs=[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
var contamimovemat=[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
var path=[]
var bottles=[]
var towers=[]

var won=true

func _ready():
	print("Waterinit")
	var copycube=get_node("Cube_0_0")
	var cubes_x_0=[]
	cubes_x_0.append(copycube)
#	cubes.append(cubes_x_0)
	for x in range(19):
#		var cubes_x_y=[]
		if(x!=0):
#			cubes.append(cubes_x_y)
			var newcubes=copycube.duplicate(true)
			newcubes.set_name(str("Cube_",x,"_",0))
			newcubes.coords.y=0
			newcubes.coords.x=x
			newcubes.translate(Vector3(2*x,0,0))
			add_child(newcubes)
#			cubes[x].append(newcubes)
		for y in range(19):
			if(y!=0):
				var newcubes=copycube.duplicate(true)
				newcubes.set_name(str("Cube_",x,"_",y))
				newcubes.coords.x=x
				newcubes.coords.y=y
				newcubes.translate(Vector3(2*x,0,-2*y))
				add_child(newcubes)
#				cubes[x].append(newcubes)
	set_process(true)
	#cubes[0][0].drain(1)
	calculateneighbours()
	calculatePath()
	print("waterinit-done")

func _process(delta):
	if(get_node("/root/savegame").actionsdone[1] and get_parent().get_node("Gate").is_hidden()):
		get_parent().get_node("Gate").show()
		setDrained()
	
	if(dirtyneighbours):
		calculateneighbours()
		#print("end is reachable: ",endIsReachable())
		dirtyneighbours=false
	if(active):
		active=false
		undermin=true
		for i in range(19):
			for j in range(19):
				var neighbours = get_node(str("Cube_",i,"_",j)).hasneighbours
				var amount = 0
				if neighbours[0]:
					var dif=heights[i][j+1]-heights[i][j]
					difs[i][j]=difs[i][j]+dif
					difs[i][j+1]=difs[i][j+1]-dif
					amount+=2
				if neighbours[1]:
					var dif=heights[i+1][j]-heights[i][j]
					difs[i][j]=difs[i][j]+dif
					difs[i+1][j]=difs[i+1][j]-dif
					amount+=2
				if neighbours[2]:
					amount+=2
				if neighbours[3]:
					amount+=2
				if(abs(difs[i][j])>0.05):
					get_node(str("Cube_",i,"_",j)).drain(-difs[i][j]/amount)
					difs[i][j]=0
					active=true
				if(undermin and heights[i][j]>0.5):
					undermin=false
		for drainpoint in drainpoints:
			if(heights[drainpoint.x][drainpoint.y]>0.05):
				get_node(str("Cube_",drainpoint.x,"_",drainpoint.y)).drain(drainpoint.z)
	for bottle in bottles:
		if(heights[path[floor(bottle.x)].x][path[floor(bottle.x)].y]>0.5):
			bottlessettopos(bottles.find(bottle),bottle.x+delta/2,delta)

func addbottles(amount):
	var bottle=get_node("Bottles_0")
	if(!bottles.empty()):
		bottle=bottle.duplicate()
		self.add_child(bottle)
	bottle.setvisible(amount)
	bottle.set_name(str("Bottles_",bottles.size()))
	bottle.set_translation(Vector3(2*path[0].x,heights[path[0].x][path[0].y]/4,-2*path[0].y))
	bottles.push_back(Vector2(0,amount))

func bottlessettopos(bottle,position,delta):
	
	var translation
	if(path.size()-1<position):
		position=path.size()-1
	if(position!=floor(position)):
		translation=Vector3(2*path[floor(position)].x,(min(heights[path[floor(position)].x][path[floor(position)].y],6.005)/3.4)-1.005,-2*path[floor(position)].y)*(1-(position-floor(position)))+Vector3(2*path[ceil(position)].x,(min(heights[path[ceil(position)].x][path[ceil(position)].y],6.005)/3.4)-1.005,-2*path[ceil(position)].y)*(1-(ceil(position)-position))
	else:
		translation=Vector3(2*path[position].x,heights[path[position].x][path[position].y],-2*path[position].x)
	#translation.y=2
	get_node(str("Bottles_",bottle)).set_translation(translation)
	bottles[bottle].x=position
	for tower in towers:
		#print(abs(translation.x-2*(tower.x-0.5))," ",(translation.z+2*(tower.y-0.5)))
		if(abs(translation.x-2*(tower.x-0.5))<2 and abs(translation.z+2*(tower.y-0.5))<2):
			#print("IT IS DOOONE")
			bottles[bottle].y-=tower.z*delta/2
			get_node(str("Bottles_",bottle)).setvisible(bottles[bottle].y)
			if bottles[bottle].y<0:
				bottles.remove(bottle)
				if(bottle!=0):
					remove_child(get_node(str("Bottles_",bottle)))

func calculateneighbours():
	
	for i in range(19):
		for j in range(19):
			var cube = get_node(str("Cube_",i,"_",j))
			cube.calculateNeighbours()
			calculatePath()

func endIsReachable():
	#calculateneighbours()
	var reachable=[]
	var endreached=false
	reachable=get_node("Cube_0_0").getReachable()
	for i in range(reachable.size()/2):
		if(reachable[i*2]==18 and reachable[i*2+1]==18):
			endreached=true
	return endreached

func calculatePath():
	for i in range(19):
		for j in range(19):
			contamimovemat[i][j]=400
	contamimovemat[0][0]=0
	var endpoints=[Vector2(0,0)]
	#var i=0
	while !endpoints.empty():
		for endpoint in endpoints:
			endpoints.remove(endpoints.find(endpoint))
			var hasneighbours=get_node(str("Cube_",endpoint.x,"_",endpoint.y)).hasneighbours
			if(hasneighbours[0] and contamimovemat[endpoint.x][endpoint.y+1]>contamimovemat[endpoint.x][endpoint.y]+1):
				contamimovemat[endpoint.x][endpoint.y+1] = contamimovemat[endpoint.x][endpoint.y]+1
				endpoints.push_back(Vector2(endpoint.x,endpoint.y+1))
			if(hasneighbours[1] and contamimovemat[endpoint.x+1][endpoint.y]>contamimovemat[endpoint.x][endpoint.y]+1):
				contamimovemat[endpoint.x+1][endpoint.y] = contamimovemat[endpoint.x][endpoint.y]+1
				endpoints.push_back(Vector2(endpoint.x+1,endpoint.y))
			if(hasneighbours[2] and contamimovemat[endpoint.x][endpoint.y-1]>contamimovemat[endpoint.x][endpoint.y]+1):
				contamimovemat[endpoint.x][endpoint.y-1] = contamimovemat[endpoint.x][endpoint.y]+1
				endpoints.push_back(Vector2(endpoint.x,endpoint.y-1))
			if(hasneighbours[3] and contamimovemat[endpoint.x-1][endpoint.y]>contamimovemat[endpoint.x][endpoint.y]+1):
				contamimovemat[endpoint.x-1][endpoint.y] = contamimovemat[endpoint.x][endpoint.y]+1
				endpoints.push_back(Vector2(endpoint.x-1,endpoint.y))
		#i+=1
	path=[]
	path.push_front(Vector2(18,18))
	for i in range(contamimovemat[18][18]):
		var hasneighbours=get_node(str("Cube_",path[0].x,"_",path[0].y)).hasneighbours
		if(hasneighbours[2] and contamimovemat[path[0].x][path[0].y]>contamimovemat[path[0].x][path[0].y-1]):
			path.push_front(Vector2(path[0].x,path[0].y-1))
		elif(hasneighbours[3] and contamimovemat[path[0].x][path[0].y]>contamimovemat[path[0].x-1][path[0].y]):
			path.push_front(Vector2(path[0].x-1,path[0].y))
		elif(hasneighbours[0] and contamimovemat[path[0].x][path[0].y]>contamimovemat[path[0].x][path[0].y+1]):
			path.push_front(Vector2(path[0].x,path[0].y+1))
		elif(hasneighbours[1] and contamimovemat[path[0].x][path[0].y]>contamimovemat[path[0].x+1][path[0].y]):
			path.push_front(Vector2(path[0].x+1,path[0].y))
		#print(path[0]," -  ",path.size())
	#if(path[0]!=Vector2(0,0)):
	#	#print(contamimovemat)


func setActive(var i):
	var b=false
	for j in range(active.size()):
		if (active[j]==i):
			b=true
	if !b:
		active.push_back(i)

func setDrained():
	for x in range(19):
		for y in range(19):
			var cube = get_node(str("Cube_",x,"_",y))
			cube.setDrained()


func setInactive(var i):
	active.erase(i)
	if(active.size()==0):
		get_node("Cube_0_0").equalizeWaterLevels()