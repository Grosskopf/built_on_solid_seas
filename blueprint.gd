extends TextureFrame
var editorgui=true

var aufgabenNr=0
var finished=false

var points=[]			#Vector2 ( PosX PosY )
var lines=[]			#Vector3 ( Index Index2 length)
var circles=[]			#Vector3 ( Index Radius y-to-x-ratio)
var circleparts=[]		#Vector2 ( Index Radius ) #Vector 3 ( Startpunkt Endpunkt winkel)
var otherLabels=[]		#Vector3 ( Index Type Value )
var aufgaben=[] 		#Vector3 ( Aufgabentyp Index Ergebnis )
						#Aufgabentyps: 0->Angle 1->Length 2->Area 3->Volume
						
var seesangles=[]
var seeslength=[]


var anglenums=[]
var lengthnums=[]
var areanums=[]
var volumenums=[]

var pickedGeodreieck=false
var mousePos=Vector2(0,0)
var pickedpoint=-1
var actualpoint=Vector2(-1000,0)
var pickedforediting
var lastpoint=Vector2(0,0)
var point2=Vector2(0,0)
var point3=Vector2(0,0)

var Background=ImageTexture.new()

var activebutton=4
var activeaufgabe=0

var Chapter=0
var Difficulty=[]

var Pricesdialog=AcceptDialog.new()

#var aufgabetmp

func _ready():
	#showTest()
	#update()
	#update()
#	set_process(true)
	get_parent().get_node("Configgui/Character").add_item("Anja",0)
	get_parent().get_node("Configgui/Character").add_item("Maurice",1)
	get_parent().get_node("Configgui/Character").add_item("Marja",2)
	get_parent().get_node("Configgui/Character").add_item("Mina",3)
	get_parent().get_node("Configgui/Character").add_item("Fritz",4)
	get_parent().get_node("Configgui/Character").add_item("Angie",5)
	get_parent().get_node("Configgui/Character").add_item("Maik",6)
	get_parent().get_node("Configgui/Character").add_item("Lucia",7)
	get_parent().get_node("Configgui/Character").add_item("Torben",8)
	get_parent().get_node("Configgui/Character").add_item("Jessica",9)
	get_parent().get_node("Configgui/Character").add_item("Jay",10)
	get_parent().get_node("Configgui/Character").add_item("Collect-Tower",11)
	get_parent().get_node("Configgui/Character").add_item("Drain-Tower",12)
	
	get_parent().get_node("Configgui/Preis").set_max(get_node("/root/global").Prices.size()-1)
#	var maxim=get_node("/root/savegame").aufgabenheader.size()-1
#	get_parent().get_node("Configgui/loadButton/SpinBox").set_max(maxim)
	
	set_process_input(true)
	set_process(true)
	get_parent().get_node("Configgui/loadButton/SpinBox").set_max(get_node("/root/savegame").aufgabenbody.size()-1)
	if(get_node("/root/savegame").Items.size()>get_node("/root/global").getItemselected() and get_node("/root/savegame").Items[get_node("/root/global").getItemselected()].aufgabe!=null):
		aufgabenNr=get_node("/root/savegame").Items[get_node("/root/global").getItemselected()].aufgabe
		var aufgabetmp=get_node("/root/savegame").getAufgabe(aufgabenNr)
		loadAufgabe(aufgabetmp)
		get_node("Configgui").hide()
		get_parent().get_node("Configgui").hide()
		editorgui=false
	elif(get_node("/root/global").aufgabeToLoad!=-1):
		var aufgabetmp=get_node("/root/savegame").getAufgabe(get_node("/root/global").aufgabeToLoad)
		loadAufgabe(aufgabetmp)
		get_node("Configgui/Chapter").hide()
	pass
	
	Input.set_mouse_mode(0)

func _process(delta):
	mousePos=get_viewport().get_mouse_pos()
	if(pickedforediting and activebutton==0):
		var changedpoint=points.find(actualpoint)
		if points.find(actualpoint)!=-1:
			points[pickedpoint]=mousePos
		for line in lines:
			if(line.x==changedpoint or line.y==changedpoint):
				var length=float(int((points[line.y]-points[line.x]).length()*5))/100
				lines[lines.find(line)].z=length
		for i in range(circleparts.size()/2):
			if(circleparts[i*2].x==changedpoint or circleparts[i*2+1].x==changedpoint or circleparts[i*2+1].y==changedpoint):
				var startangle=toangle(points[circleparts[i*2+1].x]-points[circleparts[i*2].x])
				var endangle=toangle(points[circleparts[i*2+1].y]-points[circleparts[i*2].x])
				var actualangle=(180*abs(endangle-startangle))/PI
				if actualangle>180:
					actualangle=360-actualangle
				actualangle=int(actualangle)
				circleparts[i*2+1].z=actualangle
		#mousePos=actualpoint
		update()
	if(pickedGeodreieck):
		get_parent().get_node("Control").set_pos(mousePos)
		if(pickedpoint!=-1):
			get_parent().get_node("Control").set_pos(actualpoint)
		if actualpoint!=null :
			get_parent().get_node("Control").set_rot(acos((mousePos-actualpoint).normalized().x))
			if(mousePos.y>actualpoint.y):
				get_parent().get_node("Control").set_rot(-acos((mousePos-actualpoint).normalized().x))

func _input(event):
	actualpoint=Vector2(-1000,0)
	for point in points:
		if actualpoint==Vector2(-1000,0) or (mousePos-point).length()<(mousePos-actualpoint).length():
			actualpoint=point
	update()
	if(Input.is_mouse_button_pressed(BUTTON_LEFT) and !Input.is_mouse_button_pressed(BUTTON_RIGHT)):
		if(!editorgui):
			if(mousePos.x>585 and mousePos.y<150):
				pickedGeodreieck=!pickedGeodreieck
				if pickedGeodreieck:
					get_parent().get_node("Control").set_scale(Vector2(4,4))
				else:
					get_parent().get_node("Control").set_scale(Vector2(1,1))
		elif(mousePos.x<585 and mousePos.x>135):
			pickedpoint=-1
			if((mousePos-actualpoint).length()<10):
				if(pickedpoint==-1 or activebutton==4):
					pickedpoint=points.find(actualpoint)
			if(activebutton==0):
				if(pickedpoint!=-1):
					pickedforediting=true
					var changedpoint=points.find(actualpoint)
					if points.find(actualpoint)!=-1:
						points[pickedpoint]=mousePos
					for line in lines:
						if(line.x==changedpoint or line.y==changedpoint):
							var length=float(int((points[line.y]-points[line.x]).length()*5))/100
							lines[lines.find(line)].z=length
					for i in range(circleparts.size()/2):
						if(circleparts[i*2].x==changedpoint or circleparts[i*2+1].x==changedpoint or circleparts[i*2+1].y==changedpoint):
#						if(lastpoint.x<point3.x and point2.x>point3.x and lastpoint.y < point3.y and point2.y < point3.y):
#							print("swapped!!!")
#							var tmppoint=lastpoint
#							lastpoint=point2
#							point2=tmppoint
					
							var startangle=toangle(points[circleparts[i*2+1].x]-points[circleparts[i*2].x])
							var endangle=toangle(points[circleparts[i*2+1].y]-points[circleparts[i*2].x])
							var actualangle=(180*abs(endangle-startangle))/PI
							if actualangle>180:
								actualangle=360-actualangle
							actualangle=int(actualangle)
							circleparts[i*2+1].z=actualangle
				#mousePos=actualpoint
				else:
					points.push_back(mousePos)
					pickedpoint=points.size()-1
				update()
			elif(activebutton==1 and lastpoint!=actualpoint and points.find(actualpoint)!=-1 and points.find(lastpoint)!=-1):
				var hasline=false
				print("Shouldaddline")
				for line in lines:
					if((line.x==points.find(lastpoint) and line.y==points.find(actualpoint)) or (line.y==points.find(lastpoint) and line.x==points.find(actualpoint))):
						hasline=true
				if !hasline:
					lines.push_back(Vector3(points.find(lastpoint),points.find(actualpoint),float(int((lastpoint-actualpoint).length()*5))/100))
					seeslength.push_back(true)
					update()
			elif(activebutton==2):
				var hascircle=-1
				for circle in circles:
					if(circle.x==points.find(lastpoint)):
						hascircle=circles.find(circle)
						print(circle,hascircle)
				if hascircle!=-1:
					circles[hascircle].y=(mousePos-lastpoint).length()
					circles[hascircle].z=get_node("Configgui/YRatio").get_value()
				elif points.find(lastpoint)!=-1:
					circles.push_back(Vector3(points.find(lastpoint),(mousePos-lastpoint).length(),get_node("Configgui/YRatio").get_value()))
				else:
					print("Could not add circle to ",lastpoint)
				update()
			elif(activebutton==3):
			#print(lastpoint," ",point2," ",point3)
				if(lastpoint!=point3 and point2 !=point3 and lastpoint!=point2 and points.find(lastpoint)!=-1 and points.find(point2)!=-1 and points.find(point3)!=-1):
				#print("here")
					var angleExists=false
					for i in range(circleparts.size()/2):
						if(circleparts[i*2].x==points.find(point3) and circleparts[i*2+1].x==points.find(point2) and circleparts[i*2+1].y==points.find(lastpoint)):
							angleExists=true
							circleparts[i*2].y=(mousePos-point3).length()
					if(!angleExists):
						if(lastpoint.x<point3.x and point2.x>point3.x and lastpoint.y < point3.y and point2.y < point3.y):
						#print("swapped!!!")
							var tmppoint=lastpoint
							lastpoint=point2
							point2=tmppoint
						var startangle=toangle(lastpoint-point3)
						var endangle=toangle(point2-point3)
						var actualangle=(180*(startangle-endangle))/PI
						if actualangle<0:
							actualangle+=360
					#if(actualangle<180):
					#	var pointtmp = point2
					#	point2 =lastpoint
					#	lastpoint = pointtmp
					#	startangle=toangle(lastpoint-point3)
					#	endangle=toangle(point2-point3)
					#	actualangle=(180*abs(endangle-startangle))/PI
						actualangle=int(actualangle)
					#print(startangle," ",endangle," ",actualangle)
						circleparts.push_back(Vector2(points.find(point3),(mousePos-point3).length()))
						circleparts.push_back(Vector3(points.find(point2),points.find(lastpoint),actualangle))
						seesangles.push_back(true)
					if points.find(point2)!=-1:
						pickedforediting=true
				#print(circleparts)
					update()
			elif(activebutton==5):
				if(activeaufgabe!=1):
					var ergebniss=-1
					if(activeaufgabe==0):
						for i in range(circleparts.size()/2):
							if(circleparts[i*2].x==points.find(actualpoint)):
								seesangles[i]=false
								ergebniss=circleparts[i*2+1].z
					if(activeaufgabe==2 or activeaufgabe==3):
						ergebniss=float(get_node("Configgui/LineEdit").get_text())
					var hasaufgabe=false
					for aufgabe in aufgaben:
						if aufgabe.x==activeaufgabe and aufgabe.y==points.find(actualpoint):
							hasaufgabe=true
				
					if(!hasaufgabe):
						aufgaben.push_back(Vector3(activeaufgabe,points.find(actualpoint),ergebniss))
				else:
					var acline=-1
					for line in lines:
						if acline==-1:
							acline=lines.find(line)
						else:
							if(((0.5*(points[lines[acline].x]+points[lines[acline].y]))-mousePos).length()>((0.5*(points[line.x]+points[line.y]))-mousePos).length()):
								acline=lines.find(line)
					var hasaufgabe=false
					for aufgabe in aufgaben:
						if aufgabe.x==1 and aufgabe.y==acline:
							hasaufgabe=true
					if(!hasaufgabe):
						aufgaben.push_back(Vector3(1,acline,lines[acline].z))
						seeslength[acline]=false
				update()
			elif(activebutton==6):
				var haslabeltype=-1
				var actuallabel=-1
				for otherlabel in otherLabels:
					if(otherlabel.x==points.find(actualpoint)):
						haslabeltype=otherlabel.y
						actuallabel=otherLabels.find(otherlabel)
				
				if(activeaufgabe==0):
					for i in range(circleparts.size()/2):
						if(circleparts[i*2].x==points.find(actualpoint)):
							seesangles[i]=true
				elif(activeaufgabe==1):
					var acline=-1
					for line in lines:
						if acline==-1:
							acline=lines.find(line)
						else:
							if(((0.5*(points[lines[acline].x]+points[lines[acline].y]))-mousePos).length()>((0.5*(points[line.x]+points[line.y]))-mousePos).length()):
								acline=lines.find(line)
					seeslength[acline]=true
				elif(activeaufgabe==2 and haslabeltype!= 1):
					otherLabels.push_back(Vector3(points.find(actualpoint),1,0))
					if(haslabeltype==0):
						otherLabels.remove(actuallabel)
				elif(activeaufgabe==3 and haslabeltype != 0):
					otherLabels.push_back(Vector3(points.find(actualpoint),0,0))
					if(haslabeltype==1):
						otherLabels.remove(actuallabel)
				update()
			else:
				if (points.find(point3)!=-1 or (points.find(lastpoint)!=-1 and activebutton!=3 and activebutton!=1) or (points.find(point2)!=-1 and activebutton==1)):
					point3=Vector2(0,0)
					point2=Vector2(0,0)
					lastpoint=Vector2(0,0)
					print("Deleted")
					
			if (points.find(point3)==-1 and lastpoint!=actualpoint):
				point3=point2
				point2=lastpoint
				lastpoint=actualpoint
	elif(Input.is_mouse_button_pressed(BUTTON_RIGHT)):
		if(activebutton==0):
			var todeletepoints=points.find(actualpoint)
			print("deleting point nr. ", todeletepoints," from ",points)
			if(((mousePos-actualpoint).length()<10 or pickedforediting) and todeletepoints!=-1):
				var todeletelines=[]
				var todeletecircles=[]
				var todeletecircleparts=[]
				for line in lines:
					if(line.x==todeletepoints or line.y==todeletepoints):
						todeletelines.push_back(lines.find(line))
				for i in range(circleparts.size()/2):
					if(circleparts[i*2].x==todeletepoints or circleparts[i*2+1].x==todeletepoints or circleparts[i*2+1].y==todeletepoints):
						todeletecircleparts.push_front(i*2)
						todeletecircleparts.push_front(i*2+1)
				for circle in circles:
					if(circle.x==todeletepoints):
						todeletecircles.push_back(circles.find(circle))
				for aufgabe in aufgaben:
					if aufgabe.y>todeletepoints and aufgabe.x!=1:
						aufgaben[aufgaben.find(aufgabe)].y-=1
				for otherlabel in otherLabels:
					if otherlabel.x>todeletepoints:
						otherlabel.x-=1
				for aufgabe in aufgaben:
					if todeletepoints==aufgabe.y and aufgabe.x!=1:
						aufgaben.remove(aufgaben.find(aufgabe))
						
				for i in range(todeletelines.size()):
					lines.remove(todeletelines[(todeletelines.size()-1)-i])
					seeslength.remove(todeletelines[(todeletelines.size()-1)-i])
					for aufgabe in aufgaben:
						if aufgabe.x==1 and todeletelines[(todeletelines.size()-1)-i]==aufgabe.y:
							aufgaben.remove(aufgaben.find(aufgabe))
				for i in range(todeletecircles.size()):
					circles.remove(todeletecircles[(todeletecircles.size()-1)-i])
				var helpbool=false
				for i in range(todeletecircleparts.size()):
					circleparts.remove(todeletecircleparts[(todeletecircleparts.size()-1)-i])
					if helpbool:
						seesangles.remove(todeletecircleparts[(todeletecircleparts.size()-1)-i]/2)
					helpbool=!helpbool
				points.remove(todeletepoints)
				for i in range(lines.size()):
					if(lines[i].x-todeletepoints>0):
						lines[i].x-=1
					if(lines[i].y-todeletepoints>0):
						lines[i].y-=1
				for i in range(circles.size()):
					if(circles[i].x-todeletepoints>0):
						circles[i].x-=1
				for i in range(circleparts.size()/2):
					if(circleparts[i*2].x-todeletepoints>0):
						circleparts[i*2].x-=1
					if(circleparts[i*2+1].x-todeletepoints>0):
						circleparts[i*2+1].x-=1
					if(circleparts[i*2+1].y-todeletepoints>0):
						circleparts[i*2+1].y-=1
				update()
		elif(activebutton==1):
			var acline=-1
			for line in lines:
				if acline==-1:
					acline=lines.find(line)
				else:
					if(((0.5*(points[lines[acline].x]+points[lines[acline].y]))-mousePos).length()>((0.5*(points[line.x]+points[line.y]))-mousePos).length()):
						acline=lines.find(line)
			var actualaufgabe=-1
			for aufgabe in aufgaben:
				if aufgabe.x==1 and aufgabe.y==acline:
					actualaufgabe=aufgaben.find(aufgabe)
			if(acline!=-1):
				lines.remove(acline)
			if actualaufgabe!=-1:
				aufgaben.remove(acline)
			
			for aufgabe in aufgaben:
				if aufgabe.x==1 and acline!=-1 and acline<aufgabe.y:
					aufgabe.y-=1
		elif(activebutton==2):
			for circle in circles:
				if(circle.x==points.find(lastpoint)):
					circles.remove(circles.find(circle))
					#print(circle,hascircle)
					update()
		elif(activebutton==3):
			var todeleteparts=[]
			for i in range(circleparts.size()/2):
				if(circleparts[i*2].x==points.find(actualpoint)):
					todeleteparts.push_front(i)
			for part in todeleteparts:
				circleparts.remove(part*2+1)
				circleparts.remove(part*2)
				seesangles.remove(part)
		elif(activebutton==5):
			var acline=-1
			for line in lines:
				if acline==-1:
					acline=lines.find(line)
				else:
					if(((0.5*(points[lines[acline].x]+points[lines[acline].y]))-mousePos).length()>((0.5*(points[line.x]+points[line.y]))-mousePos).length()):
						acline=lines.find(line)
			if(activeaufgabe==0):
				for i in range(circleparts.size()/2):
					if(circleparts[i*2].x==points.find(actualpoint)):
						seesangles[i]=true
			if(activeaufgabe==1):
				seeslength[acline]=true
			for aufgabe in aufgaben:
				if aufgabe.x==activeaufgabe and aufgabe.y==points.find(actualpoint) and aufgabe.x!=1:
					aufgaben.remove(aufgaben.find(aufgabe))
				elif aufgabe.x==activeaufgabe and aufgabe.y==lines.find(acline) and aufgabe.x==1:
					aufgaben.remove(aufgaben.find(aufgabe))
			update()
		elif(activebutton==6):
			
			if(activeaufgabe==0):
				for i in range(circleparts.size()/2):
					if(circleparts[i*2].x==points.find(actualpoint)):
						seesangles[i]=false
			elif(activeaufgabe==1):
				var acline=-1
				for line in lines:
					if acline==-1:
						acline=lines.find(line)
					else:
						if(((0.5*(points[lines[acline].x]+points[lines[acline].y]))-mousePos).length()>((0.5*(points[line.x]+points[line.y]))-mousePos).length()):
							acline=lines.find(line)
				seeslength[acline]=false
			else:
				for otherlabel in otherLabels:
					if(otherlabel.x==points.find(actualpoint)):
						otherLabels.remove(otherLabels.find(otherlabel))
			update()
	else:
		pickedpoint=-1
		pickedforediting=false


func _draw():
	var anglelabelamount=0
	var linelabelamount=0
	var otherlabelamount=0
	draw_texture_rect(Background,Rect2(135,0,450,450),false,Color(1,1,1,1),false)
	
	for point in points:
		draw_circle(point,3,Color(1,0,0,0.2))
		if(point==actualpoint):
			draw_circle(point,3,Color(0,1,0,0.2))
		if(point==point3):
			draw_circle(point,3,Color(0,1,1,0.5))
		if(point==point2):
			draw_circle(point,3,Color(0.5,1,0.5,0.5))
		if(point==lastpoint):
			draw_circle(point,3,Color(1,1,0,0.5))
	for circle in circles:
		for j in range(100):
			var step=2*PI/100
			var punkt1=points[circle.x]+Vector2(cos(step*j)*circle.y,circle.z*sin(step*j)*circle.y)
			var punkt2=points[circle.x]+Vector2(cos(step*(j+1))*circle.y,circle.z*sin(step*(j+1))*circle.y)
			draw_line(punkt1,punkt2,Color(0,0,0),2)
	for i in range(circleparts.size()/2):
		var startangle=toangle(points[circleparts[i*2+1].x]-points[circleparts[i*2].x])
		var endangle=toangle(points[circleparts[i*2+1].y]-points[circleparts[i*2].x])
		var step=(endangle-startangle)/100
		if(-PI>endangle-startangle):
			print("EDITED",step*100)
			step=(2*PI+endangle-startangle)/100
		print(step*100)
		for j in range(100):
			var punkt1=points[circleparts[i*2].x]+Vector2(cos(startangle+step*j)*circleparts[i*2].y,sin(startangle+step*j)*circleparts[i*2].y)
			var punkt2=points[circleparts[i*2].x]+Vector2(cos(startangle+step*(j+1))*circleparts[i*2].y,sin(startangle+step*(j+1))*circleparts[i*2].y)
			draw_line(punkt1,punkt2,Color(0,0,0),2)
		if(!has_node(str("AngleLabel",anglelabelamount))):
			var label = Label.new()
			if(editorgui):
				label = LineEdit.new()
				label.set_text(str(circleparts[i*2+1].z))
				label.connect("text_entered",self,"angleedited",[i*2+1])
				print("connected to angle",anglelabelamount)
			else:
				label.set_text(str(circleparts[i*2+1].z,"°"))
			label.set_pos(points[circleparts[i*2].x])
			label.set_name(str("AngleLabel",anglelabelamount))
			label.add_color_override("font_color",Color(0,0,0))
			add_child(label)
			if(seesangles[i]):
				label.show()
			else:
				label.hide()
		else:
			var label=get_node(str("AngleLabel",anglelabelamount))
			if(editorgui):
				label.set_text(str(circleparts[i*2+1].z))
			else:
				label.set_text(str(circleparts[i*2+1].z,"°"))
			label.set_pos(points[circleparts[i*2].x])
			if(seesangles[i]):
				label.show()
			else:
				label.hide()
		anglelabelamount+=1
	var tmp=0
	for line in lines:
		draw_line(points[line.x],points[line.y],Color(0,0,0),2)
		if(!has_node(str("LineLabel",linelabelamount))):
			var label = Label.new()
			if(editorgui):
				label = LineEdit.new()
				label.set_text(str(line.z))
				label.connect("text_entered",self,"lineedited",[lines.find(line)])
				print("connected to line",lines.find(line))
			else:
				label.set_text(str(line.z,"cm"))
			label.set_pos((points[line.x]+points[line.y])/2)
			label.set_name(str("LineLabel",linelabelamount))
			label.add_color_override("font_color",Color(0,0,0))
			add_child(label)
			if(seeslength[tmp]):
				label.show()
			else:
				label.hide()
		else:
			var label=get_node(str("LineLabel",linelabelamount))
			#print(line)
			if(editorgui):
				label.set_text(str(line.z))
			else:
				label.set_text(str(line.z,"cm"))
			label.set_pos((points[line.x]+points[line.y])/2)
			if(seeslength[tmp]):
				label.show()
			else:
				label.hide()
		linelabelamount+=1
		tmp+=1
	for otherlabel in otherLabels:
		if(!has_node(str("otherLabel",otherlabelamount))):
			var label = Label.new()
			if(editorgui):
				var lineedit = LineEdit.new()
				lineedit.set_text(str(otherlabel.z))
				lineedit.connect("text_entered",self,"otheredited",[otherLabels.find(otherlabel)])
				label.add_child(lineedit)
				print("connected to other",otherLabels.find(otherlabel))
			else:
				if(otherlabel.y==1):
					label.set_text(str(otherlabel.z,"cm²"))
				if(otherlabel.y==0):
					label.set_text(str(otherlabel.z,"cm³"))
			label.set_pos(points[otherlabel.x])
			label.set_name(str("otherLabel",otherlabelamount))
			label.add_color_override("font_color",Color(0,0,0))
			add_child(label)
		else:
			var label=get_node(str("otherLabel",otherlabelamount))
			#print(line)
			if(editorgui):
				label.set_text(str(otherlabel.z))
			else:
				if(otherlabel.y==1):
					label.set_text(str(otherlabel.z,"cm²"))
				if(otherlabel.y==0):
					label.set_text(str(otherlabel.z,"cm³"))
			label.set_pos(points[otherlabel.x])
		otherlabelamount+=1
		tmp+=1
	
	while(has_node(str("AngleLabel",anglelabelamount))):
		get_node(str("AngleLabel",anglelabelamount)).hide()
		anglelabelamount+=1
	while(has_node(str("LineLabel",linelabelamount))):
		get_node(str("LineLabel",linelabelamount)).hide()
		linelabelamount+=1
	while(has_node(str("otherLabel",otherlabelamount))):
		get_node(str("otherLabel",otherlabelamount)).hide()
		otherlabelamount+=1
	var angleamount=0
	var lineamount=0
	var surfamount=0
	var volumeamount=0
	for aufgabe in aufgaben:
		#print(aufgabe)
		var node=null
		if(aufgabe.x==0):
			if(angleamount!=0):
				if(!has_node(str("Angle", angleamount))):
					node=get_node("Angle0").duplicate(true)
					node.set_name(str("Angle",angleamount))
					node.show()
					node.set_name(str("Angle",angleamount))
					add_child(node)
				else:
					node=get_node(str("Angle",angleamount))
					node.show()
			else:
				node=get_node("Angle0")
				node.show()
			node.set_pos(points[aufgabe.y])
			if(editorgui and !get_node(str("Angle",angleamount,"/LineEdit")).is_connected("text_entered",self,"angleedited")):
				for i in range(circleparts.size()/2):
					if(circleparts[i*2].x==aufgabe.y):
						get_node(str("Angle",angleamount,"/LineEdit")).connect("text_entered",self,"angleedited",[i*2+1])
			angleamount+=1
		elif(aufgabe.x==1):
			if(lineamount!=0):
				if(!has_node(str("Length",lineamount))):
					node=get_node("Length0").duplicate(true)
					node.show()
					node.set_name(str("Length",lineamount))
					add_child(node)
				else:
					node=get_node(str("Length",lineamount))
					node.show()
			else:
				node=get_node("Length0")
				node.show()
			node.set_pos((points[lines[aufgabe.y].x]+points[lines[aufgabe.y].y])/2)
			if(editorgui and !get_node(str("Length",lineamount,"/LineEdit")).is_connected("text_entered",self,"lineedited")):
				get_node(str("Length",lineamount,"/LineEdit")).connect("text_entered",self,"lineedited",[aufgabe.y])
			lineamount+=1
		elif(aufgabe.x==2):
			if(surfamount!=0):
				if(!has_node(str("Area",surfamount))):
					node=get_node("Area0").duplicate(true)
					node.show()
					node.set_name(str("Area",surfamount))
					add_child(node)
				else:
					node=get_node(str("Area",surfamount))
					node.show()
			else:
				node=get_node("Area0")
				node.show()
			node.set_pos(points[aufgabe.y])
			if(editorgui and !get_node(str("Area",surfamount,"/LineEdit")).is_connected("text_entered",self,"aufgabeedited")):
				get_node(str("Area",surfamount,"/LineEdit")).connect("text_entered",self,"aufgabeedited",[aufgabe.y,2])
			surfamount+=1
		elif(aufgabe.x==3):
			if(volumeamount!=0):
				if(!has_node(str("Volume",volumeamount))):
					node=get_node("Volume0").duplicate(true)
					node.show()
					node.set_name(str("Volume",volumeamount))
					add_child(node)
				else:
					node=get_node(str("Volume",volumeamount))
					node.show()
			else:
				node=get_node("Volume0")
				node.show()
			node.set_pos(points[aufgabe.y])
			if(editorgui and !get_node(str("Volume",volumeamount,"/LineEdit")).is_connected("text_entered",self,"aufgabeedited")):
				get_node(str("Volume",volumeamount,"/LineEdit")).connect("text_entered",self,"aufgabeedited",[aufgabe.y,3])
			volumeamount+=1
	if(has_node(str("Angle",angleamount))):
		get_node(str("Angle",angleamount)).hide()
	if(has_node(str("Length",lineamount))):
		get_node(str("Length",lineamount)).hide()
	if(has_node(str("Area",surfamount))):
		get_node(str("Area",surfamount)).hide()
	if(has_node(str("Volume",volumeamount))):
		get_node(str("Volume",volumeamount)).hide()
	pass

func lineedited(value,number):
	lines[number].z=float(value)
	for aufgabe in aufgaben:
		if aufgabe.x==1 and aufgabe.y==number:
			aufgabe.z=float(value)
	print("line ", number," changed to ",value)
	pass

func angleedited(value,number):
	circleparts[number].z=float(value)
	for aufgabe in aufgaben:
		if aufgabe.x==0 and aufgabe.y==circleparts[number-1].x:
			aufgabe.z=float(value)
	print("angle ", number," changed to ",value)

func otheredited(value,number):
	otherLabels[number].z=float(value)

func aufgabeedited(value,number,type):
	for aufgabe in aufgaben:
		if(aufgabe.x==type and aufgabe.y==number):
			aufgabe.z=float(value)

func showTest():
	points.push_back(Vector2(360,240))
	points.push_back(Vector2(440,180))
	points.push_back(Vector2(420,160))
	points.push_back(Vector2(300,160))
	points.push_back(Vector2(400,160))
	lines.push_back(Vector3(0,1,5))
	seeslength.push_back(false)
	lines.push_back(Vector3(1,2,1))
	seeslength.push_back(true)
	lines.push_back(Vector3(0,2,5))
	seeslength.push_back(true)
	lines.push_back(Vector3(3,4,5))
	seeslength.push_back(true)
	circles.push_back(Vector3(3,100,0.5))
	circleparts.push_back(Vector2(0,20))
	circleparts.push_back(Vector3(1,2,20))
	seesangles.push_back(false)
	aufgaben.push_back(Vector3(0,0,20))
	aufgaben.push_back(Vector3( 1 , 0 ,  5 ))
	aufgaben.push_back(Vector3(2,3,80))


func toangle(var vector):
	var angle=(atan(vector.y/vector.x))
	if(vector.x<0):
		angle+=PI
	return angle

func _init():
	pass

func loadAufgabe(var tmp):
	
	if(tmp[0]!=""):
		Background.load(str("textures/",tmp[0]))
	else:
		print("NoBackGround")
	points=tmp[1]
	lines=tmp[2]
	circles=tmp[3]
	circleparts=tmp[4]
	aufgaben=tmp[5]
	otherLabels=tmp[6]
	seesangles=tmp[7]
	seeslength=tmp[8]
	get_parent().get_node("Control").set_hidden(!tmp[9])
	get_node("RichTextLabel").set_bbcode(tmp[13])
	update()
	#tmp.set_meta("visible",true)

func exportAufgabe():
	var tmp=["",[],[],[],[],[],[],[],[],false,0,0,[],"","",0]
	tmp[0]=get_node("Configgui/LineEdit 2").get_text()
	tmp[1]=points
	tmp[2]=lines
	tmp[3]=circles
	tmp[4]=circleparts
	tmp[5]=aufgaben
	tmp[6]=otherLabels
	tmp[7]=seesangles
	tmp[8]=seeslength
	tmp[9]=get_parent().get_node("Configgui/Measure").is_pressed()
	tmp[10]=get_node("Configgui/Chapter").get_value()
	tmp[11]=get_node("Configgui/Difficulty").get_value()
	for child in get_node("Configgui/Challenges").get_children():
		if(child.is_visible()):
			tmp[12].push_back(child.is_pressed())
	tmp[13]=get_parent().get_node("Configgui/Questtext").get_text()
	tmp[14]=get_parent().get_node("Configgui/Character").get_text()
	tmp[15]=get_parent().get_node("Configgui/Preis").get_value()
	var filetmp=File.new()
	var iterator=-1
	var boolean=true
	while boolean:
		iterator+=1
		boolean=filetmp.file_exists(str("Aufgaben/Kapitel_",tmp[10],"_Aufgabe_",iterator,".aufgabe"))
		if(boolean):
			print("File Exists")
	if(get_node("/root/global").aufgabeToLoad==-1):
		get_node("/root/import_export").exportBlueprint(str("Kapitel_",tmp[10],"_Aufgabe_",iterator),tmp)
	else:
		get_node("/root/import_export").exportBlueprint(str("Kapitel_",tmp[10],"_Aufgabe_",get_node("/root/global").aufgabeToLoad),tmp)

func _on_TextureButton_pressed():
	print("Pressed")
#	var done=aufgabenteil[actualAufgabe].checkFinished()
#	if(done and actualAufgabe==aufgabenteil.size()-1):
#		finished=true
#	elif(done):
#		actualAufgabe+=1
#		loadAufgabe()
	finished=true
	var anglenums=0
	var lengthnums=0
	var areanums=0
	var volumenums=0
	var partialfinished=[]
	print("Beforefor")
	for aufgabe in aufgaben:
		if aufgabe.x==0:
			var ergebniss=-1
			for i in range(circleparts.size()/2):
				if(aufgabe.y==circleparts[i*2].x):
					ergebniss=circleparts[i*2+1].z
			if(ergebniss>float(get_node(str("Angle",anglenums,"/LineEdit")).get_text())+2 or ergebniss<float(get_node(str("Angle",anglenums,"/LineEdit")).get_text())-2):
				finished=false
				partialfinished.push_back(false)
			else:
				partialfinished.push_back(true)
			anglenums+=1
		if aufgabe.x==1:
			var ergebniss=lines[aufgabe.y].z
			
			print("Ergebniss: ",ergebniss," du: ",get_node(str("Length",lengthnums,"/LineEdit")).get_text())
			if(ergebniss<float(get_node(str("Length",lengthnums,"/LineEdit")).get_text())-0.01 or ergebniss>float(get_node(str("Length",lengthnums,"/LineEdit")).get_text())+0.01):
				print("das war falsch")
				finished=false
				partialfinished.push_back(false)
			else:
				print("das war richtig")
				partialfinished.push_back(true)
			lengthnums+=1
		if aufgabe.x==2:
			var ergebniss=aufgabe.z
			var myresult=float(get_node(str("Area",areanums,"/LineEdit")).get_text())
			if(ergebniss<myresult-0.01 or ergebniss>myresult+0.01):
				finished=false
				partialfinished.push_back(false)
			else:
				partialfinished.push_back(true)
			areanums+=1
		if aufgabe.x==3:
			var ergebniss=aufgabe.z
			var myresult=float(get_node(str("Volume",volumenums,"/LineEdit")).get_text())
			if(ergebniss<myresult-0.01 or ergebniss>myresult+0.01):
				finished=false
				partialfinished.push_back(false)
			else:
				partialfinished.push_back(true)
			volumenums+=1
	print("Afterfor")
#	if(finished):
	if(!editorgui):
		get_node("/root/savegame").set_status(aufgabenNr,partialfinished)
		get_node("/root/global").setScene("res://Gameworld.scn")
	else:
		exportAufgabe()
	print("ExportedDone")
	pass # replace with function body


func _on_Cancelbutton_pressed():
	if(!editorgui):
		get_node("/root/global").setScene("res://Gameworld.scn")
	else:
		get_node("/root/global").setScene("mainmenu.scn")
	pass # replace with function body


func _on_VButtonArray_button_selected( button ):
	activebutton=button
	point3=Vector2(0,0)
	point2=Vector2(0,0)
	lastpoint=Vector2(0,0)
	pass # replace with function body


func _on_VButtonArray_2_button_selected( button ):
	activeaufgabe=button
	pass # replace with function body


func _on_Button_pressed():
	var texture=ImageTexture.new()
	texture.load(str("textures/",get_node("Configgui/LineEdit 2").get_text()))
	Background=texture
	update()
	pass # replace with function body


func _on_Chapter_value_changed( value ):
	if(value==0):
		get_node("Configgui/Challenges/Challenge1").set_text("Quadratzahlen")
		get_node("Configgui/Challenges/Challenge2").set_text("Seiten")
		get_node("Configgui/Challenges/Challenge3").set_text("Höhen/Kathetensatz")
		get_node("Configgui/Challenges/Challenge4").hide()
		get_node("Configgui/Challenges/Challenge5").hide()
	elif(value==1):
		get_node("Configgui/Challenges/Challenge1").set_text("Umfang")
		get_node("Configgui/Challenges/Challenge2").set_text("Fläche")
		get_node("Configgui/Challenges/Challenge3").set_text("Vielecke")
		get_node("Configgui/Challenges/Challenge4").set_text("Bogen")
		get_node("Configgui/Challenges/Challenge5").set_text("Kreisring")
		get_node("Configgui/Challenges/Challenge4").show()
		get_node("Configgui/Challenges/Challenge5").show()
	elif(value==2):
		get_node("Configgui/Challenges/Challenge1").set_text("Oberfläche")
		get_node("Configgui/Challenges/Challenge2").set_text("Volumen")
		get_node("Configgui/Challenges/Challenge3").set_text("Hohlzylinder")
		get_node("Configgui/Challenges/Challenge4").hide()
		get_node("Configgui/Challenges/Challenge5").hide()
	else:
		get_node("Configgui/Challenges/Challenge1").set_text("Oberfläche")
		get_node("Configgui/Challenges/Challenge2").set_text("Volumen")
		get_node("Configgui/Challenges/Challenge3").set_text("Kegel")
		get_node("Configgui/Challenges/Challenge4").set_text("Kugel")
		get_node("Configgui/Challenges/Challenge5").set_text("Pyramide")
		get_node("Configgui/Challenges/Challenge4").show()
		get_node("Configgui/Challenges/Challenge5").show()
	pass # replace with function body


func _on_PrintPrices_pressed():
	var thisText=""
	var i=0
	for price in get_node("/root/global").Prices:
		thisText=str(thisText," \n Price ",i,": ",price[0]," Punkte")
		if(price.size()>1):
			thisText=str(thisText,", Event: ",price[1])
		i+=1
	
	Pricesdialog.set_text(thisText)
	Pricesdialog.set_pos(Vector2(500,0))
	Pricesdialog.set_hidden(Pricesdialog.is_visible())
	if(!is_a_parent_of(Pricesdialog)):
		add_child(Pricesdialog)
	
	pass # replace with function body


func _on_Button_2_pressed():
	var taskString=""
	var haslines
	var hasareas
	var hasangles
	var hasvolumes
	for aufgabe in aufgaben:
		if(aufgabe.x==0):
			hasangles=true
		if(aufgabe.x==1):
			haslines=true
		if(aufgabe.x==2):
			hasareas=true
		if(aufgabe.x==3):
			hasvolumes=true
	if(get_node("Configgui/Chapter").get_value()==0):
		if(hasareas and get_node("Configgui/Challenges/Challenge1").is_pressed()):
			taskString=str(taskString," - Berechne die Flächeninhalte der Quadrate\n")
		if(haslines and get_node("Configgui/Challenges/Challenge2").is_pressed()):
			taskString=str(taskString," - Berechne Kantenlängen mit dem Satz des Pythagoras\n")
		if(haslines and get_node("Configgui/Challenges/Challenge3").is_pressed()):
			taskString=str(taskString," - Berechne Kantenlängen mit dem Höhen- oder Kathetensatz\n")
	elif(get_node("Configgui/Chapter").get_value()==1):
		if(haslines and get_node("Configgui/Challenges/Challenge1").is_pressed() and !get_node("Configgui/Challenges/Challenge3").is_pressed()):
			taskString=str(taskString," - Berechne den Umfang der Kreise\n")
		if(hasareas and get_node("Configgui/Challenges/Challenge2").is_pressed() and !get_node("Configgui/Challenges/Challenge3").is_pressed() and !get_node("Configgui/Challenges/Challenge5")):
			taskString=str(taskString," - Berechne den Flächeninhalt der Kreise\n")
		if(haslines and !get_node("Configgui/Challenges/Challenge1").is_pressed() and get_node("Configgui/Challenges/Challenge3").is_pressed()):
			taskString=str(taskString," - Berechne die fehlenden Längen der Vielecke\n")
		if(haslines and get_node("Configgui/Challenges/Challenge1").is_pressed() and get_node("Configgui/Challenges/Challenge3").is_pressed()):
			taskString=str(taskString," - Berechne den Umfang der Vielecke\n")
		if(hasareas and get_node("Configgui/Challenges/Challenge2").is_pressed() and get_node("Configgui/Challenges/Challenge3").is_pressed()):
			taskString=str(taskString," - Berechne den Flächeninhalt der Vielecke\n")
		if(haslines and get_node("Configgui/Challenges/Challenge4").is_pressed()):
			taskString=str(taskString," - Berechne die Bogenlänge\n")
		if(hasangles):
			taskString=str(taskString," - Berechne die fehlenden Winkel\n")
		if(hasareas and get_node("Configgui/Challenges/Challenge5")):
			taskString=str(taskString," - Berechne die Fläche des Kreisrings\n")
	elif(get_node("Configgui/Chapter").get_value()==2):
		if(hasareas and !get_node("Configgui/Challenges/Challenge1").is_pressed()):
			taskString=str(taskString," - Berechne die Fehlenden Flächen\n")
		if(hasareas and get_node("Configgui/Challenges/Challenge1").is_pressed() and !get_node("Configgui/Challenges/Challenge3").is_pressed()):
			taskString=str(taskString," - Berechne die Oberfläche des Zylinders\n")
		if(hasvolumes and get_node("Configgui/Challenges/Challenge2").is_pressed() and !get_node("Configgui/Challenges/Challenge3").is_pressed()):
			taskString=str(taskString," - Berechne das Volumen des Zylinders\n")
		if(hasvolumes and get_node("Configgui/Challenges/Challenge3").is_pressed()):
			taskString=str(taskString," - Berechne das Volumen des Hohlzylinders\n")
	elif(get_node("Configgui/Chapter").get_value()==3):
		var pyramid=get_node("Configgui/Challenges/Challenge5").is_pressed()
		var kegel=get_node("Configgui/Challenges/Challenge3").is_pressed()
		var ball=get_node("Configgui/Challenges/Challenge4").is_pressed()
		var surface=get_node("Configgui/Challenges/Challenge1").is_pressed()
		var volume=get_node("Configgui/Challenges/Challenge2").is_pressed()
		taskString=str(taskString,"Berechne ")
		if(volume and !surface):
			taskString=str(taskString,"das Volumen ")
		elif(volume and surface):
			taskString=str(taskString,"das Volumen und die Oberfläche ")
		elif(surface):
			taskString=str(taskString,"die Oberfläche ")
		taskString=str(taskString,"von ")
		if(pyramid and !kegel and !ball):
			taskString=str(taskString,"der Pyramide\n")
		elif(!pyramid and kegel and !ball):
			taskString=str(taskString,"dem Kegel\n")
		elif(!pyramid and !kegel and ball):
			taskString=str(taskString,"der Kugel\n")
		elif(pyramid and kegel and !ball):
			taskString=str(taskString,"der Pyramide und dem Kegel\n")
		elif(!pyramid and kegel and ball):
			taskString=str(taskString,"der Kugel und dem Kegel\n")
		elif(pyramid and !kegel and ball):
			taskString=str(taskString,"der Kugel und der Pyramide\n")
		elif(pyramid and kegel and ball):
			taskString=str(taskString,"der Pyramide, dem Kegel und der Kugel\n")
	if get_parent().get_node("Configgui/Measure").is_pressed():
		taskString=str(taskString,"du darfst die fehlenden Längen oder Winkel Messen")
	get_parent().get_node("Configgui/Questtext").set_text(taskString)
	pass # replace with function body


func _on_loadButton_pressed():
	loadAufgabe(get_node("/root/savegame").getAufgabe(get_parent().get_node("Configgui/loadButton/SpinBox").get_value()))
	pass # replace with function body
