
extends MenuButton

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	pass
	




func _on_MenuButton_pressed():
	get_parent().get_node("AcceptDialog").show()