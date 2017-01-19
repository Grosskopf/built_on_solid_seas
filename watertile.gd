
extends MeshInstance

var coords = Vector2(0,0)
var values = Vector2(6.005,0)
#var height = 6.005#1.005
var hasneighbours =[false,false,false,false]
var neighbours=[null,null,null,null]
var amountneighbours=0
var amountofchanges=0
var tmpCamount=0

func _ready():
	# Initialization here
	pass

func calculateNeighbours():
	amountneighbours==0
	neighbours=[null,null,null,null]
	
	if (coords.y<18 and !get_node("Rays/North").is_colliding()):
		neighbours[0]=get_parent().get_node(str("Cube_",coords.x,"_",coords.y+1))
		amountneighbours+=1
		hasneighbours[0]=true
	else:
		neighbours[0]=null
		hasneighbours[0]=false
	if (coords.x<18 and !get_node("Rays/East").is_colliding()):
		neighbours[1]=get_parent().get_node(str("Cube_",coords.x+1,"_",coords.y))
		amountneighbours+=1
		hasneighbours[1]=true
	else:
		neighbours[1]=null
		hasneighbours[1]=false
	if (coords.y>0 and !get_node("Rays/South").is_colliding()):
		neighbours[2]=get_parent().get_node(str("Cube_",coords.x,"_",coords.y-1))
		amountneighbours+=1
		hasneighbours[2]=true
	else:
		neighbours[2]=null
		hasneighbours[2]=false
	if (coords.x>0 and !get_node("Rays/West").is_colliding()):
		neighbours[3]=get_parent().get_node(str("Cube_",coords.x-1,"_",coords.y))
		amountneighbours+=1
		hasneighbours[3]=true
	else:
		neighbours[3]=null
		hasneighbours[3]=false

func getNeighbours():
	return neighbours
	
func getNeighbour(var i):
	#calculateNeighbours()
	if(i==0 and hasneighbours[0]):
		return neighbours[0]
	elif(i==1 and hasneighbours[1]):
		return neighbours[1]
	elif(i==2 and neighbours[2]):
		return neighbours[2]
	elif(i==3 and neighbours[3]):
		return neighbours[3]

func drain(var power):
	values.x = values.x - power
	set_translation(Vector3(2*coords.x,(min(values.x,6.005)/3.4)-1.005,-2*coords.y))
	get_node("Rays").set_translation(Vector3(0,7.005-1.175*min(values.x,6.005),0))
	get_parent().heights[coords.x][coords.y]=values.x


func setContamination(amount):
	get_node("Bottles").setvisible(amount)
	values.y=amount

func setNextCammount(amount):
	tmpCamount=amount

func applyCamount():
	get_node("Bottles").setvisible(tmpCamount)
	values.y=tmpCamount


func setDrained():
	drain(values.x)

func getReachable():
	var Reachable=[]
	Reachable.push_back(coords.x)
	Reachable.push_back(coords.y)
	for i in range(4):
		if(neighbours[i]):
			Reachable.push_back(getNeighbour(i).coords.x)
			Reachable.push_back(getNeighbour(i).coords.y)
			Reachable=getNeighbour(i).getReachable2(Reachable)
	return Reachable

func getReachable2(var Reachable):
	for i in range(4):
		var iscontained=false
		for j in range(Reachable.size()/2):
			if(getNeighbour(i)!=null):
				if(Reachable[j*2]==getNeighbour(i).coords.x and Reachable[j*2+1]==getNeighbour(i).coords.y):
					iscontained=true
		if(!iscontained and hasneighbours[i]):
			Reachable.push_back(getNeighbour(i).coords.x)
			Reachable.push_back(getNeighbour(i).coords.y)
			Reachable=getNeighbour(i).getReachable2(Reachable)
	return Reachable

func equalizeWaterLevels():
	var Reachable=[]
	Reachable=getReachable()
	var amountOfTiles=Reachable.size()/2
	var amountOfWater=0
	for i in range(amountOfTiles):
		amountOfWater+=get_parent().get_node(str("Cube_",[Reachable[i*2]],"_",[Reachable[i*2+1]])).values.x
	var middle=amountOfWater/amountOfTiles
	for i in range(amountOfTiles):
		var actualnode=get_parent().get_node(str("Cube_",[Reachable[i*2]],"_",[Reachable[i*2+1]]))
		actualnode.translate(Vector3(0,middle-actualnode.values.x,0))
		actualnode.get_node("Rays").translate(Vector3(0,actualnode.values.x-middle,0))
		actualnode.values.x=middle