
extends Button


func _ready():
	pass
	




func _on_Button_pressed():
#	get_node("/root").set_rect(Rect2(0,0,1366,768))
	var settings=get_node("/root/global").Settings
	if !settings.empty():
		if(settings[0]==0):
			get_tree().get_root().set_rect(Rect2(0,0,640,480))
		elif(settings[0]==1):
			get_tree().get_root().set_rect(Rect2(0,0,1024,768))
		elif(settings[0]==2):
			get_tree().get_root().set_rect(Rect2(0,0,1366,768))
		elif(settings[0]==3):
			get_tree().get_root().set_rect(Rect2(0,0,1440,900))
		elif(settings[0]==4):
			get_tree().get_root().set_rect(Rect2(0,0,1920,1200))
	get_node("/root/global").aufgabeToLoad=-1
	get_node("/root/global").setScene("res://charactercreationscreen.scn")
	OS.set_window_fullscreen(true)