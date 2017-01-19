
extends Control

# member variables here, example:
# var a=2
# var b="textvar"
var loader
var wait_frames=0
var time_max=4000

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func setScene(scene):
	show()
	get_node("animation/AnimatedSprite").show()
	loader= ResourceLoader.load_interactive(scene)
#	Ref<ResourceInteractiveLoader> ResourceLoader::load_interactive(scene);
	if loader == null: # check for errors
		show_error()
		return
	set_process(true)

	
	get_node("animation").play("animation")

	wait_frames = 1
#	currentScene.queue_free()


func _process(time):
	if loader == null:
		set_process(false)
		return

	if wait_frames > 0: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
		# poll your loader
		var err = loader.poll()
		if err == ERR_FILE_EOF: # load finished
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			
			break
		elif err == OK:
			update_progress()
		else: # error during loading
#			show_error()
			loader = null
			break

func update_progress():
	print("Updated ", loader.get_stage_count(), "  ", loader.get_stage())
	var progress = float(loader.get_stage()) / loader.get_stage_count()
    # update your progress bar?
	get_node("progressbar").set_value(progress*100)
	
#	var len = get_node("animation").get_current_animation_length()
#	get_node("animation").seek(progress * len, true)

    # or update a progress animation?
    #var len = get_node("animation").get_current_animation_length()

    # call this on a paused animation. use "true" as the second parameter to force the animation to update
    #get_node("animation").seek(progress * len, true)

func set_new_scene(scene_resource):
	get_node("/root/global").currentScene = scene_resource.instance()
	get_node("/root").add_child(get_node("/root/global").currentScene)
	self.queue_free() # get rid of the old scene
