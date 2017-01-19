
extends Spatial

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	setvisible(0)
	pass

func setvisible(value):
	for Child in get_children():
		Child.hide()
	if(value>0):
		get_node("Circle").show()
	if(value>1):
		get_node("Circle_001").show()
	if(value>2):
		get_node("Circle_002").show()
	if(value>3):
		get_node("Circle_003").show()
	if(value>4):
		get_node("Circle_004").show()
	if(value>5):
		get_node("Circle_005").show()
	if(value>6):
		get_node("Circle_006").show()
	if(value>7):
		get_node("Circle_007").show()

