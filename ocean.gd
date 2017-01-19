
extends Spatial

# member variables here, example:
# var a=2
# var b="textvar"


var frame=0

func _ready():
	print("oceaninit")
	set_fixed_process(true)
	for i in range(7):
		for j in range(7):
			var duplinode=null
			if(i!=0 or j!=0):
				duplinode=get_node("Quadbox_0_0").duplicate(true)
				duplinode.set_translation(Vector3(20*i,0,-20*j))
				duplinode.set_name(str("Quadbox_",i,"_",j))
				#print("Adding Child ",i," ",j)
				self.add_child(duplinode)
			for k in range(10):
				for l in range(10):
					if((i*10+k)>43 and (i*10+k)<105 and (j*10+l)>49 and (j*10+l)<69):
						#print("Hiding Child ",i," ",j," ",k," ",l)
						get_node(str("Quadbox_",i,"_",j)).get_node(str("Quad_",k,"_",l)).hide()
					else:
						#print("showing Child ",i," ",j," ",k," ",l)
						get_node(str("Quadbox_",i,"_",j)).get_node(str("Quad_",k,"_",l)).show()
	print("oceaninit done")
	pass

func fixdistance(var playerpos):
	
	playerpos/=20
	playerpos.x=floor(playerpos.x)
	playerpos.y=floor(playerpos.y)
	playerpos.z=floor(playerpos.z)
	var distance=playerpos+Vector3(-2,0,4)
	if(distance.x==-1):
		distance.x=0
	distance.z=min(distance.z,6)
	distance*=20
#	set_translation(Vector3(-20,2.9,120))
	set_translation(Vector3(distance.x,2.75,distance.z))
	#print(distance)
	distance.x+=120
	distance.z-=120
	for i in range(7):
		for j in range(7):
			for k in range(10):
				for l in range(10):
					if((i*10+distance.x/2+k)>43 and (i*10+distance.x/2+k)<105 and (j*10-distance.z/2+l)>49 and (j*10-distance.z/2+l)<69):
						if(has_node(str("Quadbox_",i,"_",j,"/Quad_",k,"_",l))):
							get_node(str("Quadbox_",i,"_",j,"/Quad_",k,"_",l)).hide()
							pass
						else:
							print("AAALAAAAAAARM!!!!")
					else:
						if(has_node(str("Quadbox_",i,"_",j,"/Quad_",k,"_",l))):
							pass
							get_node(str("Quadbox_",i,"_",j,"/Quad_",k,"_",l)).show()

func _fixed_process(delta):
	frame+=1
	if(frame==1200):
		frame==0
	var scalar=float(frame)/1200
	#print("babbabab",scalar)
	for child in get_node("Quadbox_0_0").get_children():
		child.get_material_override().set_shader_param("Scalar",scalar)

