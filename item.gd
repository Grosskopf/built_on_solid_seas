
extends Node
var aufgabe=null
var icon=null
var name="bananezitrone"

func _ready():
	# Initialization here
	pass

func generateAufgabe(number):
	loadIcon("res://textures/Icons/blueprint.png")
	aufgabe=number
	name="Aufgabe"
	#aufgabe=get_tree().get_root().get_node("/root/savegame").getTaskNr(chapter,number)
	return self

func generateItem(quest,iconin,namein):
	aufgabe=quest
	loadIcon(iconin)
	name=namein
	

func loadIcon(var name):
	var tmp=ImageTexture.new()
	tmp.load(name)
	tmp.set_size_override(Vector2(34,34))
	icon=tmp
	icon.set_path(name)

