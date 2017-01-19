
extends Node

var character
var cameraposition=0.0
#var translation=Vector3(0,3.07,5.71)

func _ready():
	# Initialization here
	character = get_node("Spatial/Character")
	set_process(true)
	set_process_unhandled_input(true)
	set_fixed_process(true)
	var index=0
	var directory=[]
	var cameraposition=0.0
	directory.push_back("anzug")
	directory.push_back("bluse+rock")
	directory.push_back("broken-anzug")
	directory.push_back("jay")
	directory.push_back("Jogginghose")
	directory.push_back("kopftuchperson")
	directory.push_back("Lumberjacklook")
	directory.push_back("matrixguy")
	directory.push_back("pinkblue-dress")
	directory.push_back("protest")
	directory.push_back("standardlook")
	for i in directory:
		get_node("Panel/VBoxContainer/Kleidung/OptionButton").add_item(i,index)
		index+=1
	var directory=[]
	index=0
	directory.push_back("glatze")
	directory.push_back("stoppeln")
	directory.push_back("kurzhaar")
	directory.push_back("zopf")
	for i in directory:
		get_node("Panel/VBoxContainer/Haarstil/OptionButton").add_item(i,index)
		index+=1
	get_node("Panel/VBoxContainer/Haarstil/OptionButton").select(2)
	get_node("Spatial/Character/Camerapointer/Camera").clear_current()
	get_node("Spatial/Camera").make_current()
	pass

func _process(delta):
	character.setValue(0,get_node("Panel/VBoxContainer/Name/LineEdit").get_text())
	character.setValue(3,get_node("Panel/VBoxContainer/Bodywidth/HSlider").get_value()/100)
	character.setValue(4,get_node("Panel/VBoxContainer/Bodywidth1/HSlider").get_value()/100)
	character.setValue(5,get_node("Panel/VBoxContainer/Bodywidth2/HSlider").get_value()/100)
	character.setValue(6,get_node("Panel/VBoxContainer/Bodyheight/HSlider").get_value()/100)
	character.setValue(7,get_node("Panel/VBoxContainer/Headwidth/HSlider").get_value()/100)
	character.setValue(8,get_node("Panel/VBoxContainer/Headlength/HSlider").get_value()/100)
	
	character.setValue(9,get_node("Panel/VBoxContainer/ColorPicker").get_color())
	character.setValue(10,get_node("Panel/VBoxContainer/ColorPicker1").get_color())
	character.setValue(11,get_node("Panel/VBoxContainer/ColorPicker2").get_color())
	
	character.setValue(2,get_node("Panel/VBoxContainer/Kleidung/OptionButton").get_item_text(get_node("Panel/VBoxContainer/Kleidung/OptionButton").get_selected()))
	character.setValue(1,get_node("Panel/VBoxContainer/Haarstil/OptionButton").get_item_text(get_node("Panel/VBoxContainer/Haarstil/OptionButton").get_selected()))
	
	var height=get_node("Panel/VBoxContainer/Bodyheight/HSlider").get_value()/25
	var translation = Vector3(-0.2*cameraposition,3.07+(height+1)*0.067*cameraposition,5.71-0.4*cameraposition)
	get_node("Spatial/Camera").set_translation(translation)

func _fixed_process(delta):
	if(Input.is_action_pressed("Walk_left")):
		get_node("Spatial/Character").rotate_y(0.05)
	if(Input.is_action_pressed("Walk_right")):
		get_node("Spatial/Character").rotate_y(-0.05)


func _unhandled_input(event):
	if(event.type==3 and event.button_index==5 and event.pressed):
		if(cameraposition>0):
			cameraposition-=0.5
	if(event.type==3 and event.button_index==4 and event.pressed):
		if(cameraposition<10):
			cameraposition+=0.5
			

func _on_Button_2_pressed():
	get_node("/root/import_export").exportCharacter(get_node("Panel/VBoxContainer/Name/LineEdit").get_text(),character)
	get_node("/root/global").PlayerName=get_node("Panel/VBoxContainer/Name/LineEdit").get_text()
	get_node("/root/global").setScene("res://Gameworld.scn")
	pass # replace with function body


func _on_Button_pressed():
	get_node("/root/global").setScene("res://mainmenu.scn")
	OS.set_window_fullscreen(false)
	pass # replace with function body
