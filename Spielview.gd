
extends Viewport

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	self.set_process(true)

func _process(delta):
	if(get_parent().is_visible()):
		if(Input.is_action_pressed("ui_close")):
			print("press exit")
			get_tree().quit()