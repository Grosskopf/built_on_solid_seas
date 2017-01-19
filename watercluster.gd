
extends Spatial

var tiles_y=[]
func _ready():
	var coppynode=get_node("Cube_0_0")
	var tiles_0_x=[]
	tiles_0_x.append(coppynode)
	tiles_y.append(tiles_0_x)
	for y in range(16):
		var tiles_y_x=[]
		if(y!=0):
			tiles_y.append(tiles_y_x)
			var newnode=coppynode.duplicate(true)
			newnode.set_name(str("Cube_",y,"_",0))
			newnode.translate(Vector3(0,0,-2*y))
			add_child(newnode)
			tiles_y[y].append(newnode)
		for x in range(16):
			if(x!=0):
				var newnode=coppynode.duplicate(true)
				newnode.set_name(str("Cube_",y,"_",x))
				newnode.translate(Vector3(2*x,0,-2*y))
				add_child(newnode)
				tiles_y[y].append(newnode)
	# Initialization here
	pass
