
extends Button

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	pass




func _on_Button_2_pressed():
	get_parent().get_parent().get_node("Credits").set_hidden(true)
	get_parent().get_parent().get_node("Settings").set_hidden(false)
	get_parent().get_parent().get_node("Loading").set_hidden(true)
	get_parent().get_parent().get_node("Aufgaben").set_hidden(true)
	get_parent().get_parent().get_node("Dialoge").set_hidden(true)
	print('Pressed')


func _on_Button_pressed():
	var panel=get_parent().get_parent().get_node("Settings")
	get_node("/root/global").setSettings([panel.get_node("HButtonArray").get_selected(),panel.get_node("CheckBox").is_pressed(),panel.get_node("CheckBox1").is_pressed(),panel.get_node("CheckBox2").is_pressed(),panel.get_node("CheckBox3").is_pressed(),panel.get_node("CheckBox4").is_pressed()])
	pass # replace with function body
