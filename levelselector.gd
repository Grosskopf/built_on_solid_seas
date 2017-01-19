
extends PopupMenu

var levelselected=0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	for level in get_parent().get_parent().get_node("Towerdefense").level:
		get_node("ScrollContainer/VButtonArray").add_button(str("Level ",get_parent().get_parent().get_node("Towerdefense").level.find(level)," Gewinn: ",level[0]))
	pass




func _on_Abbrechen_pressed():
	hide()
	pass # replace with function body


func _on_OK_pressed():
	get_parent().get_parent().get_node("Towerdefense").startlevel(levelselected)
	hide()
	pass # replace with function body


func _on_VButtonArray_button_selected( button ):
	levelselected=button
	pass # replace with function body
