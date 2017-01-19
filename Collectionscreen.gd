
extends PopupMenu

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_Button_pressed():
	get_node("Screen1").hide()
	get_node("Screen2").show()
	get_node("OK").set_disabled(false)
	pass # replace with function body


func _on_OK_pressed():
	hide()
	pass # replace with function body
