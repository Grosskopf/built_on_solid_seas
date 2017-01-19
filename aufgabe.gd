extends Control
var labels=[]
var solutions=[]
var textfields=[]
var finished=false

func _init():
	self.hide()
#	var test=[]
#	test=loadaufgabe("aufgabe")
#	aufgabenbeschreibung=[test[0],test[1],test[2],test[3],test[4]]
#	aufgabenloesung=[test[5],test[6],test[7],test[8],test[9]]
#	koordinaten=[test[10],test[11],test[12],test[13],test[14]]

#func generateTestAufgabe():
#	var file=File.new()
#	file.open("res://aufgabe.aufg",file.WRITE)
#	file.store_line("aufgabenstellung")
#	file.store_line("aufgabe1")
#	file.store_line("aufgabe2")
#	file.store_line("aufgabe3")
#	file.store_line("aufgabe4")
#	file.store_line("aufgabe5")
#	file.store_float(1)
#	file.store_float(2)
#	file.store_float(3)
#	file.store_float(4)
#	file.store_float(5)
#	file.store_16(0)
#	file.store_16(0)
#	file.store_16(0)
#	file.store_16(50)
#	file.store_16(0)
#	file.store_16(100)
#	file.store_16(0)
#	file.store_16(150)
#	file.store_16(0)
#	file.store_16(200)
#	file.close()
#	var file2=File.new()
#	file2.open("res://aufgabe2.txt",file2.WRITE)
#	file2.store_line("Aufgabenstellung")
#	file2.store_line("Aufgabe1")
#	file2.store_line("Aufgabe2")
#	file2.store_line("Aufgabe3")
#	file2.store_line("Aufgabe4")
#	file2.store_line("Aufgabe5")
#	file2.store_line("1")
#	file2.store_line("2")
#	file2.store_line("3")
#	file2.store_line("4")
#	file2.store_line("5")
#	file2.store_line("0")
#	file2.store_line("0")
#	file2.store_line("0")
#	file2.store_line("50")
#	file2.store_line("0")
#	file2.store_line("100")
#	file2.store_line("0")
#	file2.store_line("150")
#	file2.store_line("0")
#	file2.store_line("200")
#	file2.close()

func loadaufgabe(var aufgabe):
	#var test = ["test1","test2","test3","test4","test5",1,2,3,4,5,Vector2(0,0),Vector2(0,50),Vector2(0,100),Vector2(0,150),Vector2(0,200)]
#	generateTestAufgabe()
	var file=File.new()
	file.open("res://aufgabe.txt",file.READ)
#	if(!file.eof_reached())
	print(file.get_line())
	var test=[file.get_line(),file.get_line(),file.get_line(),file.get_line(),file.get_line(),file.get_float(),file.get_float(),file.get_float(),file.get_float(),file.get_float(),Vector2(file.get_16(),file.get_16()),Vector2(file.get_16(),file.get_16()),Vector2(file.get_16(),file.get_16()),Vector2(file.get_16(),file.get_16()),Vector2(file.get_16(),file.get_16())]
	print(file.get_line(),file.get_line(),file.get_line())
	return test
func getLabel(var i):
	return labels[i]
func getSolution(var i):
	return solutions[i]
func getTextField(var i):
	return textfields[i]
func getType():
	return "aufgabe"
func setFinished():
	finished=true