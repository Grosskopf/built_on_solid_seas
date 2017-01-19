
extends KinematicBody

# member variables here, example:
# var a=2
# var b="textvar"
var walking=false
func _ready():
	get_node("AnimationPlayer").play("Walkcycle")
#	self.set_process(true)
	
#func _process(delta):
#	if(Input.is_action_pressed("Walk")):
#		self.get_node("AnimationPlayer").play("Walkcycle")
#	else:
#		walking=false

