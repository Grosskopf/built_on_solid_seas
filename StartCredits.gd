
extends Button

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	pass




func _on_Credits_pressed():
	print("Das Spiel: Gerrit Großkopf")
	print("Die Betreuung:")
	print(" Lehrstuhl Wissensbasierte Systeme Uni Siegen:")
	print(" Madjid Fathi & Marjan Khobreh")
	print("Das Testen: Euregio Gesamtschule Rheine")
	print("Die Software: FOSS")
	print(" Game-Engine: Godot")
	print(" Bildbearbeitung: Gimp")
	print(" Bilderstellung: MyPaint")
	print(" Theorie: LaTeX & Libreoffice")
	print("Die Lizenz: CC-BY-NC-SA")
	get_parent().get_parent().get_node("Credits").set_hidden(false)
	get_parent().get_parent().get_node("Settings").set_hidden(true)
	get_parent().get_parent().get_node("Loading").set_hidden(true)
	get_parent().get_parent().get_node("Aufgaben").set_hidden(true)
	get_parent().get_parent().get_node("Dialoge").set_hidden(true)
	pass # replace with function body
