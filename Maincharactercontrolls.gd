
extends Spatial

# member variables here, example:
# var a=2
# var b="textvar"
var maincharacter

#animation
var walking=false
var flying=true
var ctrlpressed=false
var shiftpressed=false

var facing=0 #(0=front,2=right,4=back,6=left)

var rotation=3.14159265359/2
var yspeed=0
var walkingspeed=0
var cameraposition=Vector2(0,0)
var camera_y=0

var ismaincharacter=true

var mousemovementspeed
var framemovement=Vector3(0,0,0)
var framerotation=0
var cameraframerotation=Vector2(0,0)
#var PI=3.14159265359

var global

func _ready():
	print("Maincharacterinit")
	mousemovementspeed=Input.get_mouse_speed()
	self.set_process(true)
	self.set_fixed_process(true)
	cameraposition=Vector2(20,9)
	global=get_node("/root/global")
	self.set_process_unhandled_input(true)
	maincharacter=get_node("Maincharacter")
	get_node("Maincharacter/Camerapointer/Camera").make_current()
	get_node("Jay").setPath(get_parent().get_node("Paths/jaywalk"))
	get_node("Jay").setPauses([28,69,118])
	get_node("Jessica").setPath(get_parent().get_node("Paths/Jessicawalk"))
	get_node("Jessica").setPauses([35,37,39,41,43,75,77,79])
	get_node("Torben").setPath(get_parent().get_node("Paths/Torbenwalk"))
	get_node("Torben").setPauses([13.5,64.5,69.5,74.5,79,89.8,145.6])
	get_node("Maurice").setPath(get_parent().get_node("Paths/Mauricewalk"))
	get_node("Maurice").setPauses([3.5,7.55,15.5,19,22,26,38,59,169,172])
	get_node("Marja").setPath(get_parent().get_node("Paths/Marjawalk"))
	get_node("Marja").setPauses([3.3,8,30,70,118,149,156])
	get_node("Angie").setPath(get_parent().get_node("Paths/Angiewalk"))
	get_node("Angie").setPauses([9,18,37,39,66,76,84.5,116,123])
	get_node("Lucia").setPath(get_parent().get_node("Paths/Luciawalk"))
	get_node("Lucia").setPauses([1,6,8,10,13.5,18,21,23,25,28,50,56,70,77,94,106])
	get_node("Maik").setPath(get_parent().get_node("Paths/Maikwalk"))
	get_node("Maik").setPauses([2,28,67,69,72,114.75,152.45,207.45])
	get_node("Mina").setPath(get_parent().get_node("Paths/Minawalk"))
	get_node("Mina").setPauses([6,12.8,32,47.6,54,59.5,64,65.8,72.5,79.5])
	get_node("Anja").setPath(get_parent().get_node("Paths/Anjawalk"))
	get_node("Anja").setPauses([3,10,50,65,114,117.8,119.8,123.5,126])
	get_node("Fritz").setPath(get_parent().get_node("Paths/Fritzwalk"))
	get_node("Fritz").setPauses([3.7,5,12,50.5,106.5])
	
	print("Maincharacterinit done")
	
	
	pass


func _unhandled_input(event):
	if(event.type==3 and event.button_index==4 and event.pressed):
		if(cameraposition.y>0 and not ctrlpressed):
			cameraposition.y-=0.5
			cameraposition.x-=1.125
			maincharacter.get_node("Camerapointer").set_translation(Vector3(0,5*maincharacter.bodyheight+0.075*cameraposition.y*8,-0.5*cameraposition.y*2))
			maincharacter.get_node("Camerapointer/Camera/StaticBody/RayCast").set_translation((Vector3(0,0,-3.5-0.5*cameraposition.y*2)))
			maincharacter.get_node("Camerapointer").set_rotation(Vector3(PI*(180+1.125*4*cameraposition.y)/180,0,PI))
			if(cameraposition.y<2):
				maincharacter.get_node("CharacterArmature/Back").hide()
				maincharacter.get_node("CharacterArmature/Front").hide()
		if(ctrlpressed):
			global.setItemselected(global.getItemselected()+1)
	if(event.type==3 and event.button_index==5 and event.pressed):
		if(cameraposition.y<9 and not ctrlpressed):
			cameraposition.y+=0.5
			cameraposition.x+=1.125
			maincharacter.get_node("Camerapointer").set_rotation(Vector3(PI*(180+1.125*4*cameraposition.y)/180,0,PI))
			maincharacter.get_node("Camerapointer").set_translation(Vector3(0,5*maincharacter.bodyheight+0.075*cameraposition.y*8,-0.5*cameraposition.y*2))
			maincharacter.get_node("Camerapointer/Camera/StaticBody/RayCast").set_translation((Vector3(0,0,-3.5-0.5*cameraposition.y*2)))
			maincharacter.get_node("Camerapointer/Camera").rotate_x(-camera_y)
			camera_y=0
			if(cameraposition.y>2 and ismaincharacter):
				maincharacter.get_node("CharacterArmature/Back").show()
				maincharacter.get_node("CharacterArmature/Front").show()
		if(ctrlpressed):
			global.setItemselected(global.getItemselected()-1)

func _fixed_process(delta):
	maincharacter.move(framemovement)
	framemovement=Vector3(0,0,0)
	maincharacter.rotate_y(cameraframerotation.x/3)
	rotation+=cameraframerotation.x/3
#	maincharacter.get_node("CharacterArmature").rotate_y(cameraframerotation.x)
	cameraframerotation.x-=cameraframerotation.x/3
	maincharacter.get_node("Camerapointer/Camera").rotate_x(cameraframerotation.y/3)
	cameraframerotation.y-=cameraframerotation.y/3

func _process(delta):
	if(get_node("Jay").quests.empty()):
		get_node("Jay").quests=[load("res://item.gd").new().generateAufgabe(get_node("/root/savegame").getTaskNr(0,0))]

	if(maincharacter.is_colliding() and yspeed < 0):
		yspeed=0
		flying=false
	if(!flying and !maincharacter.is_colliding()):
		flying=true
	if(flying):
		yspeed-=0.01
		framemovement+=Vector3(0,yspeed,0)
		#self.move(Vector3(0,yspeed,0))
	if(Input.is_action_pressed("Jump") and !flying):
		yspeed=0.175
		flying=true
	if(Input.is_action_pressed("Walk")):
		if(!walking):
			maincharacter.get_node("CharacterWalkcycle").play("Walkcycle")
			walkingspeed=1
			walking=true
		if(Input.is_action_pressed("Walk_forward")):
			
			framemovement+=Vector3(0,-0.001,-.06*walkingspeed).rotated(Vector3(0,1,0),rotation)
			#self.move(Vector3(0,-0.001,-.06*walkingspeed).rotated(Vector3(0,1,0),rotation))
			if(facing!=0 and !Input.is_action_pressed("Walk_right") and !Input.is_action_pressed("Walk_left")):
				framerotation+=-(PI/4)*facing
				#self.get_node("CharacterArmature").rotate_y(-(PI/4)*facing)
				facing=0
			else:
				if(Input.is_action_pressed("Walk_right") and facing != 1):
					framerotation+=-(PI/4)*(facing-1)
					#self.get_node("CharacterArmature").rotate_y(-(PI/4)*(facing-1))
					facing=1
				if(Input.is_action_pressed("Walk_left") and facing != 7):
					framerotation+=-(PI/4)*(facing-7)
					#self.get_node("CharacterArmature").rotate_y(-(PI/4)*(facing-7))
					facing=7
		if(Input.is_action_pressed("Walk_right")):
			#self.rotate_y(.02)
			#self.rotation += 0.02
			framemovement+=Vector3(.03*walkingspeed,-0.001,0).rotated(Vector3(0,1,0),rotation)
			#self.move(Vector3(.03*walkingspeed,-0.001,0).rotated(Vector3(0,1,0),rotation))
			if(facing!=2 and !Input.is_action_pressed("Walk_forward") and !Input.is_action_pressed("Walk_back")):
				framerotation+=-(PI/4)*(facing-2)
				#self.get_node("CharacterArmature").rotate_y(-(PI/4)*(facing-2))
				facing=2
		if(Input.is_action_pressed("Walk_left")):
			#self.rotate_y(-.02)
			#self.rotation -= 0.02
			framemovement+=Vector3(-.03*walkingspeed,-0.001,0).rotated(Vector3(0,1,0),rotation)
			#self.move(Vector3(-.03*walkingspeed,-0.001,0).rotated(Vector3(0,1,0),rotation))
			if(facing!=6 and !Input.is_action_pressed("Walk_forward") and !Input.is_action_pressed("Walk_back")):
				framerotation+=-(PI/4)*(facing-6)
				#self.get_node("CharacterArmature").rotate_y(-(PI/4)*(facing-6))
				facing=6
		if(Input.is_action_pressed("Walk_back")):
			framemovement+=Vector3(0,-0.001,0.06*walkingspeed).rotated(Vector3(0,1,0),rotation)
			#self.move(Vector3(0,-0.001,0.06*walkingspeed).rotated(Vector3(0,1,0),rotation))
			if(facing!=4 and !Input.is_action_pressed("Walk_right") and !Input.is_action_pressed("Walk_left")):
				framerotation+=-(PI/4)*(facing-4)
				#self.get_node("CharacterArmature").rotate_y(-(PI/4)*(facing-4))
				facing=4
			else:
				if(Input.is_action_pressed("Walk_right") and facing != 3):
					framerotation+=-(PI/4)*(facing-3)
					#self.get_node("CharacterArmature").rotate_y(-(PI/4)*(facing-3))
					facing=3
				if(Input.is_action_pressed("Walk_left") and facing != 5):
					framerotation+=-(PI/4)*(facing-5)
					#self.get_node("CharacterArmature").rotate_y(-(PI/4)*(facing-5))
					facing=5
	else:
		if(walking):
			maincharacter.get_node("CharacterWalkcycle").stop(false)
			walking=false
	if(mousemovementspeed!=Input.get_mouse_speed() and !ctrlpressed):
		cameraframerotation.x+=0.0005*Input.get_mouse_speed().x
		if(cameraposition.y==0):
			camera_y+=0.0005*Input.get_mouse_speed().y
			cameraframerotation.y+=0.0005*Input.get_mouse_speed().y
		0.0005*Input.get_mouse_speed().y
		mousemovementspeed=Input.get_mouse_speed()
	if(Input.is_key_pressed(KEY_CONTROL)):
		ctrlpressed=true
	else:
		ctrlpressed=false
	if(Input.is_key_pressed(KEY_SHIFT)):
		shiftpressed=true
	else:
		shiftpressed=false
	if(not ismaincharacter):
		framemovement.x= -framemovement.x
		framemovement.z= -framemovement.z
	if(shiftpressed):
		framemovement.x*=2
		framemovement.z*=2
		maincharacter.get_node("CharacterWalkcycle").set_speed(2)
	else:
		maincharacter.get_node("CharacterWalkcycle").set_speed(1)
	if(isinWater()):
		respawn()
	if(Input.is_key_pressed(KEY_2)):
		print(get_parent().get_node("Paths/jaywalk/PathFollow").get_offset())
		print("numbers: ",get_node("Jay").pauses)

func isinWater():
	var characterisat=maincharacter.get_translation()
	var map=get_parent().get_node("Mapelements/Worldmap")
	characterisat.x=((characterisat.x-map.get_center_x())/2)-0.5
	characterisat.y=((characterisat.y-map.get_center_y())/2)-0.5
	characterisat.z=((characterisat.z-map.get_center_z())/2)-0.5
	return (characterisat.x<-17 or characterisat.x>44 or characterisat.z<-10 or characterisat.z>10) and characterisat.y<-0.5

func respawn():
	if(get_parent().get_node("GUI/PopupMenu4").respawned):
		get_parent().get_node("GUI/PopupMenu4").popup()
		get_parent().get_node("GUI/PopupMenu4").respawned=false
	