
extends KinematicBody
#look

var hairstyletexture
var clothingtexture
var normalmap

var name="test"
var hairstyle="glatze"
var clothing="protest"
var lowerbodywidth=0.5
var upperbodywidth=0.5
var shoulderwidth=0.5
var bodyheight=0.75
var headwidth=0.5
var headheight=0.5
var skincolor=Color(0,0,0)
var haircolor=Color(0,0,0)
var eyecolor=Color(0,0,0)
var dirtyclothing=false
var dirtyhair=false

var global

var yspeed

var path=null
var pathfollow=null
var pausewalk=0
var pauses=[]
var iswalking=false
var lastpause=-1
var quests=[]

var absolutepause=false

func _ready():
	print("character-init")
	global=get_node("/root/global")
	set_fixed_process(true)
	print("character-init done")
	

func setshowquestsign(boolean):
	get_node("hasquest").set_hidden(!boolean)

func _fixed_process(delta):
	pass
	if(path!=null and !absolutepause):
		move_on_path()
	elif absolutepause:
		get_node("CharacterWalkcycle").play("Idle")
		iswalking=false
		if(get_parent().has_node("Maincharacter")):
			var viewto=get_parent().get_node("Maincharacter").get_translation()-self.get_translation()
			#print(viewto)
			if(viewto.z>0):
				set_rotation(Vector3(0,atan(viewto.x/viewto.z),0))
			else:
				set_rotation(Vector3(0,PI+atan(viewto.x/viewto.z),0))
			

func move_on_path():
	if(pathfollow==null):
		pathfollow=path.get_node("PathFollow")
	var offset=pathfollow.get_offset()
	path.get_curve().get_baked_length()
	if(pausewalk<1):
		pathfollow.set_offset(offset+0.024)
		if(offset>path.get_curve().get_baked_length()):
			pathfollow.set_offset(offset+0.024-path.get_curve().get_baked_length())
		set_translation(pathfollow.get_translation())
		var rotation=pathfollow.get_rotation()
		set_rotation(rotation)
		rotate_y(PI)
		if(!iswalking):
			get_node("CharacterWalkcycle").play("Walkcycle")
			iswalking=true
	else:
		if(iswalking):
			get_node("CharacterWalkcycle").play("Idle")
			iswalking=false
		pausewalk-=1
		
	var tmpbool=false
	for pause in pauses:
		if(pause<offset and pause+0.5>offset and pause!=lastpause):
			tmpbool=true
			lastpause=pause
	if(tmpbool):
		if iswalking:
			pausewalk=300

func setPauses(var pausesIn):
	pauses=pausesIn

func setPath(var inpath):
	path=inpath
	

func loadCharacter(var char):
	self.name=char.name
	self.hairstyle=char.hairstyle
	hairstyletexture=ImageTexture.new()
	hairstyletexture.load(str("textures/Colormaps/Hairstyles/",hairstyle,".png"))
	hairstyletexture.set_flags(5)
	self.clothing=char.clothing
	self.clothingtexture=ImageTexture.new()
	self.clothingtexture.load(str("textures/clothing/Finished/",clothing,".png"))
	self.normalmap=ImageTexture.new()
	if(clothing=="matrixguy"):
		normalmap.load("textures/clothing/Finished/normalmap_matrixguy.png")
	elif(clothing=="pinkblue-dress" or clothing=="bluse+rock"):
		normalmap.load("textures/clothing/Finished/normalmap_Kurzer_Rock.png")
	elif(clothing=="kopftuchperson"):
		normalmap.load("textures/clothing/Finished/normalmap_Langer_Rock.png")
	else:
		normalmap.load("textures/clothing/Finished/normalmap_Hose.png")
	self.lowerbodywidth=char.lowerbodywidth
	self.upperbodywidth=char.upperbodywidth
	self.shoulderwidth=char.shoulderwidth
	self.bodyheight=char.bodyheight
	self.headwidth=char.headwidth
	self.headheight=char.headheight
	self.skincolor=char.skincolor
	self.haircolor=char.haircolor
	self.eyecolor=char.eyecolor
	self.updateBody()

func setValue(var i, var to):
	if(i==0):
		name=to
	if(i==1 and to != null and to!=clothing):
		hairstyletexture=ImageTexture.new()
		hairstyletexture.load(str("textures/Colormaps/Hairstyles/",to,".png"))
		hairstyletexture.set_flags(5)
		hairstyle=to
	if(i==2 and to != null and to!=clothing):
		clothingtexture=ImageTexture.new()
		clothingtexture.load(str("textures/clothing/Finished/",to,".png"))
		normalmap=ImageTexture.new()
		if(to=="matrixguy"):
			normalmap.load("textures/clothing/Finished/normalmap_matrixguy.png")
		elif(to=="pinkblue-dress" or to=="bluse+rock"):
			normalmap.load("textures/clothing/Finished/normalmap_Kurzer_Rock.png")
		elif(to=="kopftuchperson"):
			normalmap.load("textures/clothing/Finished/normalmap_Langer_Rock.png")
		else:
			normalmap.load("textures/clothing/Finished/normalmap_Hose.png")
		clothing=to
		#print(clothing.get_path())
		dirtyclothing=true
	if(i==3):
		lowerbodywidth=0.5+to
	if(i==4):
		upperbodywidth=0.5+to
	if(i==5):
		shoulderwidth=0.5+to/2
	if(i==6):
		bodyheight=0.75+to/2
	if(i==7):
		headwidth=0.5+to
	if(i==8):
		headheight=0.5+to
	if(i==9):
		skincolor=to
	if(i==10):
		haircolor=to
	if(i==11):
		eyecolor=to
	updateBody()

func updateBody():
	var armature=get_node("CharacterArmature")
	armature.set_bone_custom_pose(0,Transform(Vector3(bodyheight*(lowerbodywidth/2+0.5),0,0),Vector3(0,1,0),Vector3(0,0,bodyheight),Vector3(0,0,0)))
	armature.set_bone_custom_pose(1,Transform(Vector3(lowerbodywidth,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(0,0,0)))
	armature.set_bone_custom_pose(2,Transform(Vector3(upperbodywidth/lowerbodywidth,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(0,0,0)))
	armature.set_bone_custom_pose(3,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,shoulderwidth/upperbodywidth),Vector3(0,0,0)))
	armature.set_bone_custom_pose(6,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,shoulderwidth/upperbodywidth),Vector3(0,0,0)))
	armature.set_bone_custom_pose(9,Transform(Vector3(headwidth/upperbodywidth,0,0),Vector3(0,1,0),Vector3(0,0,headheight),Vector3(0,0,0)))
	armature.set_translation(Vector3(0,2.5*bodyheight-2.5,0))
	get_node("Camerapointer").set_translation(Vector3(0,7+(bodyheight-0.75)*2.5,-9))
	var front=get_node("CharacterArmature/Front").get_material_override()
	var back=get_node("CharacterArmature/Back").get_material_override()
	front.set_shader_param("Skincolor",skincolor)
	back.set_shader_param("Skincolor",skincolor)
	front.set_shader_param("Eyecolor",eyecolor)
	front.set_shader_param("Haircolor",haircolor)
	back.set_shader_param("Haircolor",haircolor)
	front.set_shader_param("Clothing",clothingtexture)
	front.set_shader_param("Normalmap",normalmap)
	back.set_shader_param("Normalmap",normalmap)
	back.set_shader_param("Clothing",clothingtexture)
	front.set_shader_param("Hairstyle",hairstyletexture)
	back.set_shader_param("Hairstyle",hairstyletexture)
	var bustsize=max((upperbodywidth-0.8)*0.75,0)
	front.set_shader_param("Bustsize",bustsize)
	
func getQuest():
	if(quests.empty()):
		return null
	else:
		var Quest=quests[0]
		return Quest

func giveBackQuest(Quest):
	if(get_node("/root/savegame").isSolved(Quest.aufgabe)):
		get_node("/root/savegame").addPoints(100)
		get_node("/root/global").updateGUI()