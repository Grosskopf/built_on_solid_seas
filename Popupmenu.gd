
extends PopupMenu

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_Save_pressed():
	get_node("/root/savegame").saveGame()
	get_node("Notification").show()
	pass # replace with function body0


func _on_Load_pressed():
	get_node("/root/savegame").loadLastGame()
	get_node("Notification2").show()
	pass # replace with function body


func _on_Menu_pressed():
	get_node("/root/global").setScene("res://mainmenu.scn")
	pass # replace with function body


func _on_Beenden_pressed():
	get_tree().quit()
	pass # replace with function body
