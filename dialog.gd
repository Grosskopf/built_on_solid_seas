
extends Control

var Dialogpart=["", "","","", "","", null,null, -1]
var Dialognr=-1

var tfield 
var afield
var wfield
var dfield

var number=0
#Text, 3Antwortmöglichkeiten, zwei Erläuterungen, item to win, item to give, type
#type:
	#0-> Quest bekommen
	#1-> Reden
	#2-> Quest abgeben
	#3-> Tauschhandel

func _ready():
	set_process(false)
	tfield= get_node("Textfield/Text")
	afield= get_node("AField/Label")
	wfield= get_node("WField/Label")
	dfield= get_node("DField/Label")
	pass

func _process(delta):
	number+=1
	tfield.set_visible_characters(number)
	print("Numberrrrrr", number)


func showdialog(DP,number):
	self.show()
	Dialogpart=DP
	Dialognr=number
	print("Showing Dialog nr ", number)
	tfield.set_bbcode(Dialogpart[0].replace("*",get_node("/root/global").getPlayerName()))
	wfield.set_bbcode(Dialogpart[1].replace("*",get_node("/root/global").getPlayerName()))
	afield.set_bbcode(Dialogpart[2].replace("*",get_node("/root/global").getPlayerName()))
	dfield.set_bbcode(Dialogpart[3].replace("*",get_node("/root/global").getPlayerName()))
	set_process_input(true)
	set_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func closedialog():
	set_process_input(false)
	set_process(false)
	number=0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().get_parent().get_node("Characters/Angie").absolutepause=false
	get_parent().get_parent().get_node("Characters/Anja").absolutepause=false
	get_parent().get_parent().get_node("Characters/Fritz").absolutepause=false
	get_parent().get_parent().get_node("Characters/Jay").absolutepause=false
	get_parent().get_parent().get_node("Characters/Jessica").absolutepause=false
	get_parent().get_parent().get_node("Characters/Lucia").absolutepause=false
	get_parent().get_parent().get_node("Characters/Maik").absolutepause=false
	get_parent().get_parent().get_node("Characters/Marja").absolutepause=false
	get_parent().get_parent().get_node("Characters/Maurice").absolutepause=false
	get_parent().get_parent().get_node("Characters/Mina").absolutepause=false
	get_parent().get_parent().get_node("Characters/Torben").absolutepause=false
	self.hide()
	

func W_pressed():
	tfield.set_bbcode(str(Dialogpart[0].replace("*",get_node("/root/global").getPlayerName()),"\n\n",Dialogpart[4].replace("*",get_node("/root/global").getPlayerName())))
	if(Dialognr==11):
		tfield.set_bbcode(str(Dialogpart[0].replace("*",get_node("/root/global").getPlayerName()),"\n\n",get_node("/root/savegame").getActiveJessicamessage().replace("*",get_node("/root/global").getPlayerName())))
		number=Dialogpart[0].replace("*",get_node("/root/global").getPlayerName()).length()
	pass

func A_pressed():
	var finished=true
	if(Dialogpart[8]==0):
		var newItem=load("res://item.gd").new()
		newItem.generateItem(Dialogpart[6][0],Dialogpart[6][1],Dialogpart[6][2])
		get_node("/root/savegame").addItem(newItem)
		closedialog()
	elif(Dialogpart[8]==1):
		tfield.set_bbcode(str(Dialogpart[0].replace("*",get_node("/root/global").getPlayerName()),"\n\n",Dialogpart[5].replace("*",get_node("/root/global").getPlayerName())))
	elif(Dialogpart[8]==2):
		if(get_node("/root/savegame").getActiveName()==Dialogpart[7][2] and get_node("/root/savegame").isSolved(get_node("/root/savegame").getActiveAufgabe())):
			get_node("/root/savegame").gatherReward(get_node("/root/savegame").getActiveAufgabe())
			get_node("/root/savegame").removeItem(Dialogpart[7][2])
			closedialog()
		else:
			tfield.set_bbcode(str(Dialogpart[0].replace("*",get_node("/root/global").getPlayerName()),"\n\n",Dialogpart[5].replace("*",get_node("/root/global").getPlayerName())))
			number=Dialogpart[0].replace("*",get_node("/root/global").getPlayerName()).length()
			finished=false
	elif(Dialogpart[8]==3):
		get_node("/root/savegame").removeItem(Dialogpart[7][2])
		var newItem=load("res://item.gd").new()
		newItem.generateItem(Dialogpart[6][0],Dialogpart[6][1],Dialogpart[6][2])
		get_node("/root/savegame").addItem(newItem)
		closedialog()
	if(finished):
		get_node("/root/savegame").setDialogfinisched(Dialognr)
	pass

func D_pressesd():
	closedialog()
	pass

func _input(event):
	if Input.is_key_pressed(KEY_X):
		W_pressed()
	if Input.is_key_pressed(KEY_Y):
		A_pressed()
	if Input.is_key_pressed(KEY_C):
		D_pressesd()


func _on_TextureFrame3_pressed():
	D_pressesd()
	pass # replace with function body


func _on_TextureFrame2_pressed():
	W_pressed()
	pass # replace with function body


func _on_TextureFrame1_pressed():
	A_pressed()
	pass # replace with function body
