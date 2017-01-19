
extends Spatial

var surroundingwalls=[false,false,true,true]
var sec=0

func _ready():
	set_fixed_process(true)
	pass
	

func setsurroundingwalls(array):
	surroundingwalls=array

func generatedfunc(x):
	if(x<=1.0/8):
		#print("1")
		if(surroundingwalls[0]):
			return 1-4*x
		else:
			return 4*x
	elif(x<=2.0/8):
		#print("2")
		if(surroundingwalls[1]):
			return 4*x
		else:
			return 1-4*x
	elif(x<=3.0/8):
		#print("3")
		if(surroundingwalls[1]):
			return 1+1-4*x
		else:
			return 4*x-1
	elif(x<=4.0/8):
		#print("4")
		if(surroundingwalls[2]):
			return 4*x-1
		else:
			return 1+1-4*x
	elif(x<=5.0/8):
		#print("5")
		if(surroundingwalls[2]):
			return 2+1-4*x
		else:
			return 4*x-2
	elif(x<=6.0/8):
		#print("6")
		if(surroundingwalls[3]):
			return 4*x-2
		else:
			return 2+1-4*x
	elif(x<=7.0/8):
		#print("7")
		if(surroundingwalls[3]):
			return 3+1-4*x
		else:
			return 4*x-3
	else:
		#print("8")
		if(surroundingwalls[0]):
			return 4*x-3
		else:
			return 3+1-4*x

func getarm(index):
	if(index==0):
		return 0
	elif(index==1):
		return 2
	elif(index==2):
		return 4
	elif(index==3):
		return 1
	elif(index==4):
		return 3
	elif(index==5):
		return 5

func _fixed_process(delta):
	sec=sec+delta/5
	if(sec>1):
		sec-=1
	var Identity=Matrix3(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1))
	for i in range(6):
		var tmpsec = sec+(float(i)/6)
		if tmpsec>1:
			tmpsec-=1
		var functionres=generatedfunc(tmpsec)
		#print(" ",i," ",tmpsec)
		#print(" ",i," ",tmpsec," ",functionres)
		#print(tmpsec)
		var rotation=Identity.rotated(Vector3(1,0,0),(1-functionres)*PI/3)
		get_node("Armature").set_bone_custom_pose(getarm(i)+2,Transform(rotation,Vector3(0,0,0)))

