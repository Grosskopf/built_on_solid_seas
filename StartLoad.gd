
extends Button

# member variables here, example:
# var a=2
# var b="textvar"
var saves=[]

func _ready():
	var amount=0
	var booltmp=true
	while booltmp:
		if(File.new().file_exists(str("Saves/save",amount,".save"))):
			saves.push_back(str("Speicherstand ",amount," von ",get_node("/root/import_export").importMetadata(amount)[0]," ",get_node("/root/import_export").importMetadata(amount)[1]," Punkte"))
			amount+=1
		else:
			booltmp=false
	for save in saves:
		get_parent().get_parent().get_node("Loading/ScrollContainer/VButtonArray").add_button(save)
	pass




func _on_Loadgame_pressed():
	get_parent().get_parent().get_node("Credits").set_hidden(true)
	get_parent().get_parent().get_node("Settings").set_hidden(true)
	get_parent().get_parent().get_node("Loading").set_hidden(false)
	get_parent().get_parent().get_node("Aufgaben").set_hidden(true)
	get_parent().get_parent().get_node("Dialoge").set_hidden(true)
	pass # replace with function body


func _on_VButtonArray_button_selected( button ):
	get_node("/root/savegame").loadGame(button)
	#get_node("/root").set_rect(Rect2(0,0,1366,768))
	get_node("/root/global").aufgabeToLoad=-1
	get_node("/root/global").setScene("res://Gameworld.scn")
	OS.set_window_fullscreen(true)
	pass # replace with function body
