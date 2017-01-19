
extends PopupMenu

# member variables here, example:
# var a=2
# var b="textvar"
var respawned=true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func setto(text,rein):
	get_node("RichTextLabel").set_bbcode(text)
	respawned=rein
	pass

func _on_OK_pressed():
	get_parent().get_parent().get_node("Characters/Maincharacter").set_translation(Vector3(-16,-0.8,9.5))
	get_node("RichTextLabel").set_bbcode("Game Over\n\nDu bist offenbar schwimmen gegangen ohne schwimmen zu können, naja zum glück wachst du zuhause wieder auf, ok?")
	respawned=true
	get_parent().get_parent().get_node("Characters/Maincharacter").set_translation(Vector3(-16,-0.8,9.5))
	print("HEEEY")
	hide()
	pass # replace with function body
