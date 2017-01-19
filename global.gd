extends Node

var currentScene = null
var worldscene=false
var PlayerName = "Gerrit"
var ItemSelected=0
var aufgabeToLoad=-1
var dialogToLoad=-1
var Inventory
var Prices=[]
var Settings=[]

func getItemselected():
	return ItemSelected
func setItemselected(i):
	if(i==-1):
		ItemSelected=9
	if(i==10):
		ItemSelected=0
	if(i<10 and i>-1):
		ItemSelected=i

func setSettings(array):
	Settings=array

func getPlayerName():
	return PlayerName

func _ready():
#	Items.push_back(load("res://item.gd").new().generateItem())
	currentScene=get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1 )
	generatePrices()

func generatePrices():
	Prices.push_back([100])
	Prices.push_back([100,"Hälfte1"])
	Prices.push_back([100,"Chap1done"])
	Prices.push_back([100,"Door"])
	Prices.push_back([100,"TowerLv2"])
	Prices.push_back([100,"Tools1"])
	Prices.push_back([100,"Tools2"])

func reward(name):
	if(name=="Door"):
		get_node("/root/savegame").actionsdone[1]=true
	elif(name=="Hälfte1"):
		get_node("/root/savegame").actionsdone[2]=true
		if(get_tree().get_root().has_node("Welt")):
			get_tree().get_root().get_node("Welt").updateTowervisibility()
			get_tree().get_root().get_node("Welt/GUI/PopupMenu5").popup()
		get_node("/root/savegame").Resources+=200
		updateGui()
	elif(name=="Chap1done"):
		get_node("/root/savegame").actionsdone[3]=true
	elif(name=="TowerLv2"):
		#get_node("/root/savegame").actionsdone[4]=true
		#if(get_tree().get_root().has_node("Welt")):
		#	get_tree().get_root().get_node("Welt").updatetowervisibility()
		pass
	elif(name=="Tools1"):
		
		var tools1=load("res://item.gd").new()
		tools1.generateItem(null,"res://textures/Tool1.png","Tool1")
		get_node("/root/savegame").addItem(tools1)
		if(get_tree().get_root().has_node("Welt")):
			get_tree().get_root().get_node("Welt/GUI/PopupMenu6").popup()
		get_node("/root/savegame").Resources+=200
		updateGui()
	elif(name=="Tools2"):
		get_node("/root/savegame").deleteTools()
		get_node("/root/savegame").addItem(get_node("/root/item").generateItem(-1,"res://textures/Tool2.png","Tool2"))
	pass

func setScene(scene):
#	currentScene.free()
#	get_tree().get_root().print_tree()
#	if(get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1).has_node("Loadingscreen")):
#		get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1).get_node("Loadingscreen").setScene(scene)
#		print("LOADINGSCREEN")
#	else:
#	print("ELSE")
	currentScene.queue_free()
	var s = ResourceLoader.load("res://Loadingscreen.scn")
#	var loader=ResourceInteractiveLoader.new()
#	Ref<ResourceInteractiveLoader> ResourceLoader.load_interactive(scene)
#	var stagecount= loader.get_stage_count()
#	var s = Ref<Resource> loader.get_resource()
	currentScene= s.instance()
	get_tree().get_root().add_child(currentScene)
	get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1).setScene(scene)
	#get_tree().change_scene(scene)
	updateGui()

func updateGui():
	if(get_tree().get_root().has_node("Welt/GUI")):
		get_tree().get_root().get_node("Welt/GUI/PointsLabel").set_text(str(get_node("/root/savegame").Points," Points"))
		get_tree().get_root().get_node("Welt/GUI/Resources/Label").set_text(str(get_node("/root/savegame").Resources))