
extends PopupMenu

# member variables here, example:
# var a=2
# var b="textvar"
var screen=0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_OK_pressed():
	get_node("/root/savegame").actionsdone[0]=true
	hide()
	pass # replace with function body


func _on_Button_pressed():
	screen+=1
	get_node(str("Screen",screen)).hide()
	get_node(str("Screen",screen+1)).show()
	if(screen==8):
		get_node("OK").set_disabled(false)
	pass # replace with function body
